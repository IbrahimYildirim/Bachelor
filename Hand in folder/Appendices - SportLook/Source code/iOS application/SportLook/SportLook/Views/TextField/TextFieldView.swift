//
//  TextFieldView.swift
//  SportLook
//
//  Created by Terminator on 02/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class TextFieldView: UIView {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var icon: UIImageView!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    func setup(){
        self.backgroundColor = UIColor.COLOR_TEXT_FIELD_BACKGROUND
        textField.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 15)
        textField.textColor = UIColor.COLOR_TEXT_FIELD_TEXT
    }
}
