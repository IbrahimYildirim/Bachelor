//
//  SignupStepOneViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SignupStepOneViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBLoginViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var nameFieldContainerView: UIView!
    @IBOutlet weak var emailFieldContainerView: UIView!
    @IBOutlet weak var passwordFieldContainerView: UIView!
    @IBOutlet weak var confirmPasswordFieldContainerView: UIView!
    @IBOutlet weak var locationFieldContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var useMyLocationButton: UIButton!
    @IBOutlet weak var imgProfilePhoto: UIImageView!
    @IBOutlet weak var vwScrollView: UIScrollView!
    @IBOutlet weak var vwContentView: UIView!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    var nameField:TextFieldView!
    var emailField:TextFieldView!
    var passwordField:TextFieldView!
    var confirmPasswordField:TextFieldView!
    var locationField:TextFieldView!
    
    var imagePicker : UIImagePickerController?
//    var justLoggedOutFb = false
    var imagePicked : UIImage?
    
    init() {
        super.init(nibName: "SignupStepOneViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubviews()
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        imagePicker = UIImagePickerController()
        //round image
        imgProfilePhoto.layer.cornerRadius = imgProfilePhoto.frame.size.width / 2
        imgProfilePhoto.clipsToBounds = true
    }
    
    func addSubviews(){
        
        nameField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        nameFieldContainerView.addSubview(nameField)
        
        emailField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        emailFieldContainerView.addSubview(emailField)
        
        passwordField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        passwordFieldContainerView.addSubview(passwordField)
        
        confirmPasswordField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        confirmPasswordFieldContainerView.addSubview(confirmPasswordField)
        
        locationField = NSBundle.mainBundle().loadNibNamed("TextFieldView", owner: nil, options: nil)[0] as! TextFieldView
        locationFieldContainerView.addSubview(locationField)
    }
    
    func setLayout(){
        
        self.title = "Sign Up"
        self.view.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        vwScrollView.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        vwContentView.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        self.setCustomBackButton()
        
        nextButton.setTitle("Next", forState: UIControlState.Normal)
        nextButton.tintColor = UIColor.COLOR_BUTTON_TEXT
        nextButton.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND
        nextButton.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 18)
        
        orLabel.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 17)
        orLabel.textColor = UIColor.COLOR_LOGIN_OR
        
        nameField.textField.placeholder = "Name"
        nameField.textField.keyboardType = UIKeyboardType.NamePhonePad
        nameField.textField.returnKeyType = UIReturnKeyType.Next
        nameField.textField.tag = 1
        nameField.textField.delegate = self
        nameField.icon.image = UIImage(named: "ic_name")
        
        emailField.textField.placeholder = "Email"
        emailField.textField.keyboardType = UIKeyboardType.EmailAddress
        emailField.textField.returnKeyType = UIReturnKeyType.Next
        emailField.textField.tag = 2
        emailField.textField.delegate = self
        emailField.icon.image = UIImage(named: "ic_email")
        
        passwordField.textField.placeholder = "Password"
        passwordField.textField.secureTextEntry = true
        passwordField.textField.returnKeyType = UIReturnKeyType.Next
        passwordField.textField.tag = 3
        passwordField.textField.delegate = self
        passwordField.icon.image = UIImage(named: "ic_password")
        
        confirmPasswordField.textField.placeholder = "Confirm password"
        confirmPasswordField.textField.secureTextEntry = true
        confirmPasswordField.textField.returnKeyType = UIReturnKeyType.Next
        confirmPasswordField.textField.tag = 4
        confirmPasswordField.textField.delegate = self
        confirmPasswordField.icon.image = UIImage(named: "ic_password")
        
        locationField.textField.placeholder = "City, Country"
        locationField.textField.returnKeyType = UIReturnKeyType.Done
        locationField.textField.tag = 5
        locationField.textField.delegate = self
        locationField.icon.image = UIImage(named: "ic_location")
        
        useMyLocationButton.backgroundColor = UIColor.COLOR_TEXT_FIELD_BACKGROUND
//        let useMyLocationResizedImage : UIImage = Utils.RBResizeImage(UIImage(named: "ic_use_my_location"), targetSize: CGSizeMake(23, 23))!
//        useMyLocationButton.setImage(useMyLocationResizedImage, forState: UIControlState.Normal)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
        imgProfilePhoto.layer.borderWidth = 4.0
        imgProfilePhoto.layer.borderColor = UIColor.COLOR_PROFILE_PHOTO_BORDER.CGColor
        imgProfilePhoto.image = image
        imagePicked = image
    }
    
    //MARK: User location Methods
    
    @IBAction func useMyLocationButtonTapped(sender: UIButton) {

        UserLocationHandler.getUserLocation({ (response) -> Void in

            self.updateUserLocation(response.city + ", " + response.country)
        }, failure: { (error) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
            }
        })
    }
    
    func updateUserLocation(address: String){

        //http://stackoverflow.com/questions/25603390/swift-update-label-with-html-content-takes-1min/25603877#25603877
        
        dispatch_async(dispatch_get_main_queue()) {
            self.locationField.textField.text = address
        }
    }
    
    //MARK: Uploading picture requests
    
    func getFacebookProfilePicture(facebookId: String) -> UIImage {
        
        let facebookUrl = Constants.Facebook.facebookGraphUrl + facebookId + Constants.Facebook.facebookProfilePicturePath
        let url = NSURL(string: facebookUrl)
        let data = NSData(contentsOfURL: url!)
        return UIImage(data: data!)!
    }
    
    func performUploadProfilePictureRequest(){
        
        let provider = UploadImageProvider()
        provider.uploadProfilePicture(imagePicked!, success: { (response) -> Void in
                println("Uploaded profile picture")
            }) { (error) -> Void in
                println("Failed to upload profile picture")
        }
    }
    
    func performUploadProfilePictureFromFacebookRequest(facebookId: String){
        
        let provider = UploadImageProvider()
        provider.uploadProfilePicture(getFacebookProfilePicture(facebookId), success: { (response) -> Void in

            self.showCompletedAndHideWithCompletion("Signed up \n with Facebook!", delay: 0, hideDelay: 1, completion: { () -> Void in
                self.showSelectFavouriteSports()
            })
            }) { (error) -> Void in
                
                //Temporary showing next screen, even if request fails
                self.showCompletedAndHideWithCompletion("Signed up \n with Facebook!", delay: 0, hideDelay: 1, completion: { () -> Void in
                    self.showSelectFavouriteSports()
                })
                
//                self.hideSpinner(0.5)
//                let alert = SCLAlertView()
//                alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
        }
    }
    
    //MARK: Performing requests
    
    func performSignUpRequest(){
        
        let name = nameField.textField.text
        let email = emailField.textField.text
        let password = passwordField.textField.text
        let address = locationField.textField.text
        
        if(email.isEmpty || password.isEmpty || name.isEmpty || address.isEmpty){
            
            let alert = SCLAlertView()
            alert.showError("Oups!", subTitle: "Input fields are not valid!", closeButtonTitle: "Ok")
//        } else if (imagePicked == nil){
//            let alert = SCLAlertView()
//            alert.showWarning("Oups!", subTitle: "Choose a profile picture first!", closeButtonTitle: "Ok")
        } else{
            let loginProvider = LoginProvider()
            showLoading("Signing \n up...", delay: 0)
            loginProvider.signup(email, password: password, name: name, address: address, success: { (response) -> Void in
                
                if(self.imagePicked != nil){
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        //Background Task
                        self.performUploadProfilePictureRequest()
                        dispatch_async(dispatch_get_main_queue()) {
                            //UI Changes in main task
                            self.showSelectFavouriteSports()
                        }
                    }
                    
                } else {
                    self.showCompletedAndHideWithCompletion("Signed up!", delay: 0, hideDelay: 1, completion: { () -> Void in
                        self.showSelectFavouriteSports()
                    })
                }
//                self.showCompletedAndHideWithCompletion("Signed up!", delay: 0, hideDelay: 1, completion: { () -> Void in
//                })
                }) { (error) -> Void in
                    
                    self.hideSpinner(0.5)
                    let alert = SCLAlertView()
                    alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
            }
        }
    }
    
    func performSignUpWithFacebookRequest(user: FBGraphUser!){
        
        let email = user.objectForKey("email") as! String //may be empty if user signed up with a phone number
        let name = user.name
        let facebookToken = Constants.Facebook.facebookToken as String
        var address = "Unknown location"
        if(user.location != nil) {
            address = user.location.name
        }
        
        let loginProvider = LoginProvider()
        showLoading("Signing \n up...", delay: 0)
        loginProvider.signupWithFacebook(email, name: name, address: address, facebookToken: facebookToken, success: { (response) -> Void in
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                //Background Task
                self.performUploadProfilePictureFromFacebookRequest(user.objectID)
                dispatch_async(dispatch_get_main_queue()) {
                    //UI Changes in main task
                    self.showSelectFavouriteSports()
                }
            }

            }) { (error) -> Void in
                
                self.logOutFromFacebook()
                self.hideSpinner(0.5)
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: error.message, closeButtonTitle: "Ok")
                //Here will need to pass 'error' to an ErrorHandler
        }
    }
    
    func showSelectFavouriteSports(){
        
        self.showCompletedAndHide("Signed up!", delay: 0, hideDelay: 1)
        let controller = SignupStepTwoViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func logOutFromFacebook() {
        if (FBSession.activeSession().isOpen)
        {
            FBSession.activeSession().closeAndClearTokenInformation()
            println("Just logged out Facebook!")
        }
    }

    //MARK: Button actions
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        view.endEditing(true)
        performSignUpRequest()
    }
    
    @IBAction func profilePhotoViewTapped(sender: UITapGestureRecognizer) {
        
        println("Profile photo will change")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker!.delegate = self
            imagePicker!.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker!.allowsEditing = false
            
            self.presentViewController(imagePicker!, animated: true, completion: nil)
        }

    }
    
    //MARK: FBDelegate Methods
    
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("You signed up with FB!")
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        println(user)
        
        //adjust for production - if statement not needed
//        if (!justLoggedOutFb){
            performSignUpWithFacebookRequest(user)
//        } else {
//            justLoggedOutFb = false
//        }
    }
    
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("You're NOT signed up with FB!")
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
