//
//  ButtonView.swift
//  SportLook
//
//  Created by Terminator on 02/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class ButtonView: UIView {

    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        setup() //uncomment when it works
    }
    
    func setup(){
        
        button.tintColor = UIColor.COLOR_BUTTON_TEXT //not sure if it works
//        button.setTitleColor(UIColor.COLOR_BUTTON_TEXT, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_REGULAR, size: 18)
    }
    
}
