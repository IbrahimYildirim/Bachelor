//
//  DiscoverTableViewCell.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 17/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var imgvProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None;
        // Initialization code
        
        imgvProfile.layer.cornerRadius = 40
        imgvProfile.clipsToBounds = true
        imgvProfile.layer.borderWidth = 1.0
        imgvProfile.layer.borderColor = UIColor.COLOR_PROFILE_PHOTO_BORDER.CGColor
    }
}
