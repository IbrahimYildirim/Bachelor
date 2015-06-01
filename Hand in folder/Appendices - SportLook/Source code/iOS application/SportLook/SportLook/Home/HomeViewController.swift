//
//  HomeViewController.swift
//  SportLook
//
//  Created by Terminator on 27/02/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var backgroundWebView: UIWebView!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    init() {
        super.init(nibName: "HomeViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupLayout(){
        
        self.setCustomBackButton()
        logoLabel.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 30)
        
        loginButton.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND_LOGIN
        loginButton.setTitleColor(UIColor.COLOR_BUTTON_BACKGROUND_SIGNUP, forState: UIControlState.Normal)
        loginButton.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)
        signupButton.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND_SIGNUP
        signupButton.setTitleColor(UIColor.COLOR_BUTTON_BACKGROUND_LOGIN, forState: UIControlState.Normal)
        signupButton.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)
        
        //Call if we want animated background
//        setupBackground()
    }
    
    func setupBackground(){
        
        var filePath = NSBundle.mainBundle().pathForResource("sportlook", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        backgroundWebView.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        backgroundWebView.userInteractionEnabled = false;
    }
    
    @IBAction func loginTapped(sender: UIButton) {
        
        let controller = LoginViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        
        let controller = SignupStepOneViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
