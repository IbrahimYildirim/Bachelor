//
//  EventsTableViewCell.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 12/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory : UILabel!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyle.None;
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
