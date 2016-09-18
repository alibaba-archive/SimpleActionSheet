//
//  ActionCell.swift
//  Demo
//
//  Created by Zhu Shengqi on 6/6/16.
//  Copyright © 2016 dia. All rights reserved.
//

import UIKit
import SnapKit

class ActionCell: UITableViewCell {
    fileprivate(set) lazy var titleLabel: UILabel! = {
        let titleLabel = UILabel()
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.cyan
        
        return titleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        
        titleLabel.snp_makeConstraints { make in
            make.center.equalTo(contentView)
        }
    }
}
