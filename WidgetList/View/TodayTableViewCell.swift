//
//  TodayTableViewCell.swift
//  SSLauncher
//
//  Created by toomoo on 2015/01/27.
//  Copyright (c) 2015年 toomoo. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // ウィジェット内で下線が端まで引かれるようにする。
//        self.separatorInset = UIEdgeInsetsZero
//        self.layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
