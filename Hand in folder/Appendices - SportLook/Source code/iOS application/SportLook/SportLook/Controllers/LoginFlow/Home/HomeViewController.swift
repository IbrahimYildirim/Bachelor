//
//  HomeViewController.swift
//  SportLook
//
//  Created by Terminator on 27/02/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var testingFontLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        
    }
    
    override init() {
        super.init(nibName: "HomeViewController", bundle: nil)
        
    }
    
    func setupLayout(){
        
//        self.view.backgroundColor = UIColor.COLOR_BLACK_DARK
        self.title = "Home"
        testingFontLabel.font = UIFont(name: UIFont.QUICKSAND_LIGHT, size: 25)
        self.setCustomBackButton()
    }
    
    @IBAction func loginTapped(sender: UIButton) {
        
        println("login tapped")
        
        let controller = LoginViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        
        println("signup tapped")
        
        let controller = SignupStepOneViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

}
