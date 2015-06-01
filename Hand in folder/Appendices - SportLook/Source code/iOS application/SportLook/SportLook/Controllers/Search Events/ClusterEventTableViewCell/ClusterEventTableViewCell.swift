//
//  ClusterEventTableViewCell.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 23/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class ClusterEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblCategory : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }
    
}
