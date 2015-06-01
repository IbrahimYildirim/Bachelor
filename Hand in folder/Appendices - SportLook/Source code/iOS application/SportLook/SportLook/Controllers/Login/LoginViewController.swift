//
//  LoginViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, FBLoginViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    @IBOutlet weak var emailTextFieldContentView: UIView!
    @IBOutlet weak var passwordTextFieldContentView: UIView!
    
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var emailField:TextFieldView!
    var passwordField:TextFieldView!
//    var justLoggedOutFb = false
    
    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()

        addSubviews()
        setLayout()
        
        //For testing Facebook - remove in production
//        if (FBSession.activeSession().isOpen)
//        {
//            FBSession.activeSession().closeAndClearTokenInformation()
//            println("Just logged out Facebook!")
//            justLoggedOutFb = true
//        }
    
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = Constants.Facebook.readPermissions
    }
    
    func addSubviews(){
        
        emailField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        emailTextFieldContentView.addSubview(emailField)
        
        passwordField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        passwordTextFieldContentView.addSubview(passwordField)
    }
    
    func setLayout(){
        
        self.title = "Log In"
        self.view.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        
        orLabel.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 17)
        orLabel.textColor = UIColor.COLOR_LOGIN_OR
        
        loginButton.setTitle("Log In", forState: UIControlState.Normal)
        loginButton.tintColor = UIColor.COLOR_BUTTON_TEXT
        loginButton.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND
        loginButton.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)

        emailField.textField.placeholder = "Email"
        emailField.textField.keyboardType = UIKeyboardType.EmailAddress
        emailField.textField.returnKeyType = UIReturnKeyType.Next
        emailField.textField.tag = 1
        emailField.textField.delegate = self
        emailField.icon.image = UIImage(named: "ic_email")
        
        passwordField.textField.placeholder = "Password"
        passwordField.textField.secureTextEntry = true
        passwordField.textField.returnKeyType = UIReturnKeyType.Done
        passwordField.textField.tag = 2
        passwordField.textField.delegate = self

        passwordField.icon.image = UIImage(named: "ic_password")
    }
    
    func showTabBarController(loginResponse: LoginResponse){
        let controller = SportLookTabBarController()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    
    func performLoginRequest(){
        
        let email : String = emailField.textField.text
        let password : String = passwordField.textField.text
        // TODO: Real validation for fields here
        
        if(email.isEmpty || password.isEmpty){
            
            let alert = SCLAlertView()
            alert.showError("Oups!", subTitle: "Email or password not valid!", closeButtonTitle: "Ok")
            
        } else{
            let loginProvider = LoginProvider()
            showLoading("Logging \n in...", delay: 0)
            loginProvider.login(email, password: password, success: { (response) -> Void in
                
                self.showCompletedAndHide("Logged in!", delay: 0, hideDelay: 1)
                self.showTabBarController(response)
                }) { (error) -> Void in
                    
                    self.hideSpinner(0.5)
                    let alert = SCLAlertView()
//                    alert.showError("Oups!", subTitle: "Something went wrong. Try again!", closeButtonTitle: "Ok")
                    alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
                    //Here will need to pass 'error' to an ErrorHandler
            }
        }
    }
    
    func performLoginWithFacebookRequest(user: FBGraphUser!){
        
        let email = user.objectForKey("email") as! String
        let facebookToken = Constants.Facebook.facebookToken as String
        
        let loginProvider = LoginProvider()
        showLoading("Logging \n in...", delay: 0)
        loginProvider.loginWithFacebook(email, facebookToken: facebookToken, success: { (response) -> Void in
            
            self.showCompletedAndHide("Logged in \n with Facebook!", delay: 0, hideDelay: 1)
            self.showTabBarController(response)
            
            }) { (error) -> Void in
                
                self.logOutFromFacebook()
                self.hideSpinner(0.5)
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
                //Here will need to pass 'error' to an ErrorHandler
        }
    }
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        view.endEditing(true)
        performLoginRequest()
    }
    
    func logOutFromFacebook() {
        if (FBSession.activeSession().isOpen)
        {
            FBSession.activeSession().closeAndClearTokenInformation()
            println("Just logged out Facebook!")
        }
    }
    
    //MARK: FBDelegate Methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("You're logged in with FB!")
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        println(user)
        
        //adjust for production - if statement not needed
//        if (!justLoggedOutFb){
            performLoginWithFacebookRequest(user)
//        } else {
//            justLoggedOutFb = false
//        }
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("You're NOT logged in with FB!")
    }
    
    func loginView(loginView: FBLoginView!, handleError error: NSError!) {
        println("Error @Facebook: \(error.localizedDescription)")
    }
    
    //MARK: UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        let nextResponder = self.view.viewWithTag(nextTag)
        
        if (nextResponder != nil) {
            nextResponder?.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}
