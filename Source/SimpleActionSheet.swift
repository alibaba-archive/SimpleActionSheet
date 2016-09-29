//
//  SimpleActionSheet.swift
//  SimpleActionSheet
//
//  Created by Zhu Shengqi on 6/6/16.
//  Copyright © 2016 dia. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - SimpleActionSheetDataSource
public protocol SimpleActionSheetDataSource: class {
    func numberOfActionCellsFor(_ actionSheet: SimpleActionSheet) -> Int
    
    func heightForActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> CGFloat
    
    func actionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> UITableViewCell
    
    func cancellingButtonFor(_ actionSheet: SimpleActionSheet) -> UIButton?
}

public extension SimpleActionSheetDataSource {
    func numberOfActionCellsFor(_ actionSheet: SimpleActionSheet) -> Int {
        return 0
    }
    
    func heightForActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> CGFloat {
        return 44
    }
    
    func actionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> UITableViewCell {
        fatalError("Error: method actionCellAt(_:forActionSheet:) not implemented.")
    }
    
    func cancellingButtonFor(_ actionSheet: SimpleActionSheet) -> UIButton? {
        return nil
    }
}

// MARK: - SimpleActionSheetDelegate
public protocol SimpleActionSheetDelegate: class {
    func willSelectActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> Int?
    
    func didSelectActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet)
    
    func didTapCancellingButton(actionSheet: SimpleActionSheet)
}

public extension SimpleActionSheetDelegate {
    func willSelectActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> Int? {
        return row
    }
    
    func didSelectActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) {}
    
    func didTapCancellingButton(actionSheet: SimpleActionSheet) {}
}

// MARK: - SimpleActionSheet
open class SimpleActionSheet: UIViewController {
    // MARK: - Properties
    open var separatorColor: UIColor? {
        get {
            return tableView.separatorColor
        }
        set {
            tableView.separatorColor = newValue
        }
    }
    
    open var cornerRadius: CGFloat {
        get {
            return tableView.layer.cornerRadius
        }
        set {
            tableView.layer.cornerRadius = newValue
        }
    }
    
    open var cancelButtonHeight: CGFloat = 57
    
    open fileprivate(set) lazy var tableView: UITableView! = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        
        tableView.separatorInset = UIEdgeInsets.zero
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 44
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 1))
        
        return tableView
    }()
    
    open weak var dataSource: SimpleActionSheetDataSource?
    open weak var delegate: SimpleActionSheetDelegate?
    
    fileprivate var isFirstAppear = true
    
    fileprivate var cancellingButton: UIButton? {
        didSet {
            if let button = cancellingButton {
                button.layer.cornerRadius = tableView.layer.cornerRadius
                button.clipsToBounds = true
                
                button.addTarget(self, action: #selector(self.cancellingButtonTapped), for: .touchUpInside)
            }
        }
    }
    
    fileprivate lazy var containerView: UIView! = {
        let containerView = UIView()
        
        return containerView
    }()
    
    // MARK: - Init & Deinit
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        modalPresentationStyle = .overCurrentContext
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .overCurrentContext
    }
    
    // MARK: - VC Life Cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showActionSheet()
    }
    
    // MARK: - UI Config
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.clear
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.blankAreaTapped))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(containerView)
        
        do {
            containerView.addSubview(tableView)
            cancellingButton = dataSource?.cancellingButtonFor(self)
            
            if let cancellingButton = cancellingButton {
                tableView.snp.remakeConstraints { make in
                    make.left.equalTo(containerView).offset(10)
                    make.right.equalTo(containerView).offset(-10)
                    make.top.equalTo(containerView)
                    
                    var tableViewHeight: CGFloat = 0
                    if let numberOfCells = dataSource?.numberOfActionCellsFor(self) {
                        for row in 0..<numberOfCells {
                            tableViewHeight += dataSource?.heightForActionCellAt(row, forActionSheet: self) ?? 44
                        }
                    }
                    
                    make.height.equalTo(tableViewHeight)
                }
                
                cancellingButton.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh + 1, for: .horizontal)
                
                containerView.addSubview(cancellingButton)
                cancellingButton.snp.remakeConstraints { make in
                    make.left.equalTo(tableView)
                    make.right.equalTo(tableView)
                    make.top.equalTo(tableView.snp.bottom).offset(7)
                    make.bottom.equalTo(containerView)
                    make.height.equalTo(cancelButtonHeight)
                }
            } else {
                tableView.snp.remakeConstraints { make in
                    make.edges.equalTo(containerView)
                    
                    var tableViewHeight: CGFloat = 0
                    if let numberOfCells = dataSource?.numberOfActionCellsFor(self) {
                        for row in 0..<numberOfCells {
                            tableViewHeight += dataSource?.heightForActionCellAt(row, forActionSheet: self) ?? 44
                        }
                    }
                    
                    make.height.equalTo(tableViewHeight)
                }
            }
        }
        
        containerView.snp.remakeConstraints { make in
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view.snp.bottom)
        }
    }
    
    // MARK: - Action Handlers
    func cancellingButtonTapped() {
        delegate?.didTapCancellingButton(actionSheet: self)

        dismissActionSheet {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func blankAreaTapped() {
        delegate?.didTapCancellingButton(actionSheet: self)
        
        dismissActionSheet {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MAKR: - UI Animation
    fileprivate func showActionSheet() {
        guard isFirstAppear else {
            return
        }
        
        isFirstAppear = false
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.containerView.snp.remakeConstraints { make in
                make.top.greaterThanOrEqualTo(self.topLayoutGuide.snp.bottom)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.bottom.equalTo(self.view).offset(-9)
            }
            
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            
            }, completion: nil)
    }
    
    fileprivate func dismissActionSheet(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions(), animations: {
            self.containerView.snp.remakeConstraints { make in
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.top.equalTo(self.view.snp.bottom)
            }
            
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            
            }, completion: { finished in
                completion()
        })
    }
}

// MARK: - UITableView DataSource
extension SimpleActionSheet: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfActionCellsFor(self) ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSource!.actionCellAt((indexPath as NSIndexPath).row, forActionSheet: self)
    }
}

// MARK: - UITableView Delegate
extension SimpleActionSheet: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataSource?.heightForActionCellAt((indexPath as NSIndexPath).row, forActionSheet: self) ?? 44
    }

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let row = delegate?.willSelectActionCellAt((indexPath as NSIndexPath).row, forActionSheet: self) , row == (indexPath as NSIndexPath).row {
            return indexPath
        } else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.didSelectActionCellAt((indexPath as NSIndexPath).row, forActionSheet: self)

        dismissActionSheet {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - UIGestureRecognizer Delegate
extension SimpleActionSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: containerView) ?? false {
            return false
        } else {
            return true
        }
    }
}
