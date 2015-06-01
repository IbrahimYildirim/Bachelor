//
//  SLInputview.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 10/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SLInputview: UIView, UITextFieldDelegate {

    @IBOutlet var view: UIView!
    @IBOutlet weak var txtField : UITextField!
    @IBOutlet weak var imgvIcon : UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Load Interface
        NSBundle.mainBundle().loadNibNamed("SLInputView", owner: self, options: nil)
        self.addSubview(self.view)
    }
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    func setup(){
        
        self.backgroundColor = UIColor.COLOR_TEXT_FIELD_BACKGROUND
        self.txtField.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 15)
        self.txtField.textColor = UIColor.COLOR_TEXT_FIELD_TEXT
        
        self.txtField.delegate = self
    }
    
    func setTextField(placeHolder: String, keyboardType: UIKeyboardType!, image: UIImage!, returnKey: UIReturnKeyType!)
    {
        self.txtField.placeholder = placeHolder
        
        if keyboardType != nil {
            self.txtField.keyboardType = keyboardType
        }
        
        if returnKey != nil {
            self.txtField.returnKeyType = returnKey
        }
        
        self.imgvIcon.image = image
        
    }

}
