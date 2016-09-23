//
//  ViewController.swift
//  Demo
//
//  Created by Zhu Shengqi on 6/6/16.
//  Copyright © 2016 dia. All rights reserved.
//

import UIKit
import SimpleActionSheet
import SnapKit

class ViewController: UIViewController {
    
    lazy var strangeButton: CustomButton! = {
        let strangeButton = CustomButton()
        
        strangeButton.setTitle("click here", for: UIControlState())
        strangeButton.setTitleColor(UIColor.cyan, for: UIControlState())
        strangeButton.addTarget(self, action: #selector(self.strangeButtonTapped), for: .touchUpInside)
        
        return strangeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(strangeButton)
        strangeButton.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(view)
        }
    }
    
    func strangeButtonTapped() {
        let actionSheet = SimpleActionSheet()
        
        actionSheet.dataSource = self
        actionSheet.delegate = self
        
        actionSheet.tableView.register(ActionCell.self, forCellReuseIdentifier: "ActionCell")
        
        present(actionSheet, animated: false, completion: nil)
    }
}

extension ViewController: SimpleActionSheetDataSource {
    func numberOfActionCellsFor(_ actionSheet: SimpleActionSheet) -> Int {
        return 3
    }
    
    func heightForActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> CGFloat {
        return 44
    }
    
    func actionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) -> UITableViewCell {
        let cell = actionSheet.tableView.dequeueReusableCell(withIdentifier: "ActionCell") as! ActionCell
        
        cell.titleLabel.text = "Cell at \(row)"
        
        return cell
    }
    
    func cancellingButtonFor(_ actionSheet: SimpleActionSheet) -> UIButton? {
        let button = CustomButton(type: .custom)
        
        button.backgroundColor = UIColor.white
        button.setTitle("Cancel", for: UIControlState())
        button.setTitleColor(UIColor.cyan, for: UIControlState())
        button.snp.makeConstraints { (make) in
            make.height.equalTo(44)
        }
        
        return button
    }
}

extension ViewController: SimpleActionSheetDelegate {
    func didSelectActionCellAt(_ row: Int, forActionSheet actionSheet: SimpleActionSheet) {
        print("didSelectActionCellAt \(row)")
    }
    
    func didTapCancellingButton() {
        print("didTapCancellingButton")
    }
}

class CustomButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = UIColor.gray
            } else {
                backgroundColor = UIColor.white
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inside = super.point(inside: point, with: event)
        
        if inside != isHighlighted && event?.type == .touches {
            isHighlighted = inside
        }
        
        return inside
    }
}

