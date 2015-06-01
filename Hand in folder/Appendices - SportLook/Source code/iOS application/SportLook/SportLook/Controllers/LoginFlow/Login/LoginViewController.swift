//
//  LoginViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var lblUser : UILabel!
    @IBOutlet weak var lblPass : UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var txtUser : UITextField!
    @IBOutlet weak var txtPass : UITextField!
    @IBOutlet weak var btnLogIn: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    override init() {
        super.init(nibName: "LoginViewController", bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setLayout()
    }
    
    func setLayout(){
        
        self.title = "Log In"
        self.view.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        
        lblUser.font = UIFont.fontAwesomeOfSize(26)
        lblUser.text = String.fontAwesomeIconWithName(FontAwesome.User)
        
        lblPass.font = UIFont.fontAwesomeOfSize(26)
        lblPass.text = String.fontAwesomeIconWithName(FontAwesome.Key)
        
        lblOr.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 17)
        lblOr.textColor = UIColor.COLOR_LOGIN_OR
        
        btnLogIn.setTitle("Log In", forState: UIControlState.Normal)
        btnLogIn.tintColor = UIColor.COLOR_BUTTON_TEXT
        btnLogIn.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND
        btnLogIn.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)
        
        btnFacebook.setTitle("Log in with Facebook", forState: UIControlState.Normal)
        btnFacebook.tintColor = UIColor.COLOR_BUTTON_TEXT
        btnFacebook.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND_FACEBOOK
        btnFacebook.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)
        
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        
        println("You logged in.")
    }
    
    @IBAction func loginWithFacebookButtonTapped(sender: UIButton) {
        
        println("You logged in with Facebook.")
    }

}
