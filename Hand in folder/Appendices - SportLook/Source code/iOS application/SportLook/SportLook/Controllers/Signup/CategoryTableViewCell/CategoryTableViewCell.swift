//
//  CategoryTableViewCell.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 02/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lblIcon : UILabel!
    @IBOutlet weak var lblCategory : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        


    }
    
}
