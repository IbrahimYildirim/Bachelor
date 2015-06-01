//
//  AttendedEventTableViewCell.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 09/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class AttendedEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblCity : UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
