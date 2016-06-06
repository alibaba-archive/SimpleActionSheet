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
    
    lazy var strangeButton: UIButton! = {
        let strangeButton = UIButton()
        
        strangeButton.setTitle("click here", forState: .Normal)
        strangeButton.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        strangeButton.addTarget(self, action: #selector(self.strangeButtonTapped), forControlEvents: .TouchUpInside)
        
        return strangeButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(strangeButton)
        strangeButton.snp_makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    func strangeButtonTapped() {
        let actionSheet = SimpleActionSheet()
        
        actionSheet.dataSource = self
        actionSheet.delegate = self
        
        actionSheet.tableView.registerClass(ActionCell.self, forCellReuseIdentifier: "ActionCell")
        
        presentViewController(actionSheet, animated: false, completion: nil)
    }
}

extension ViewController: SimpleActionSheetDataSource {
    func numberOfActionCellsFor(actionSheet: SimpleActionSheet) -> Int {
        return 3
    }
    
    func heightForActionCellAt(row: Int, forActionSheet actionSheet: SimpleActionSheet) -> CGFloat {
        return 44
    }
    
    func actionCellAt(row: Int, forActionSheet actionSheet: SimpleActionSheet) -> UITableViewCell {
        let cell = actionSheet.tableView.dequeueReusableCellWithIdentifier("ActionCell") as! ActionCell
        
        cell.titleLabel.text = "Cell at \(row)"
        
        return cell
    }
    
    func cancellingButtonFor(actionSheet: SimpleActionSheet) -> UIButton? {
        let button = UIButton(type: .Custom)
        
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("Cancel", forState: .Normal)
        button.setTitleColor(UIColor.cyanColor(), forState: .Normal)
        
        button.snp_makeConstraints { (make) in
            make.height.equalTo(44)
        }
        
        return button
    }
}

extension ViewController: SimpleActionSheetDelegate {
    func didSelectActionCellAt(row: Int, forActionSheet actionSheet: SimpleActionSheet) {
        print("didSelectActionCellAt \(row)")
    }
    
    func didTapCancellingButton() {
        print("didTapCancellingButton")
    }
}
