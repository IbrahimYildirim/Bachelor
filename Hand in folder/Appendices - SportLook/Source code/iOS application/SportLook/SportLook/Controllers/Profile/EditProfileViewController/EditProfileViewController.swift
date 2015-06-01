//
//  EditProfileViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 09/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var slNameField : SLInputview!
    @IBOutlet weak var slEmailField : SLInputview!
    @IBOutlet weak var slLocationField : SLInputview!
    @IBOutlet weak var imgvProfile : UIImageView!
    
    @IBOutlet weak var btnChangeFavSports : UIButton!
    
    
    var imagePicker = UIImagePickerController()
    
    var user : User?
    var imageChanged : Bool = false
    
    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Edit Profile"
        self.setCustomBackButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("updateClicked"))
        
        setUpLayout()
        imgvProfile.alpha = 0.0
        
        if user != nil {
            slNameField.txtField.text = user?.fullName
            slEmailField.txtField.text = user?.email
            slLocationField.txtField.text = user?.location
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        imgvProfile.layer.cornerRadius = imgvProfile.frame.size.width / 2
        imgvProfile.clipsToBounds = true
        imgvProfile.layer.borderWidth = 2.0
        imgvProfile.layer.borderColor = UIColor.COLOR_PROFILE_PHOTO_BORDER.CGColor
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.imgvProfile.alpha = 1
            }, completion: nil)
        
        if user?.image != nil {
            if !imageChanged {
                imgvProfile.image = UIImage(data: (user?.image)!)
            }
        }
    }
    
    init() {
        super.init(nibName: "EditProfileViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Button Events
    @IBAction func changeFavSportsclicked(sender: AnyObject) {
        
        let controller = ChangeFavSportsViewController()
        controller.selectedItems = (user?.favSports)!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func changePicture(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func updateClicked() {
        
        self.user?.fullName = slNameField.txtField.text
        self.user?.email = slEmailField.txtField.text
        self.user?.location = slLocationField.txtField.text
        
        self.showLoading("Updating", delay: 0)
        ProfileProvider.updateProfile(KeychainHandler.getUserLoggedToken()!, user: self.user!, success: { () -> Void in
            
            ProfileViewController.Static.userChanged = true
            self.hideSpinner(0.5)
            
            if self.imageChanged {
                println("Image Changed")
                ProfileViewController.Static.imageChanged = true
                ProfileViewController.Static.imageData = UIImagePNGRepresentation(self.imgvProfile.image)
                
                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    //Background Task
                    self.uploadImage()
                    dispatch_async(dispatch_get_main_queue()) {
                        //UI Changes in main task
                        self.getBackToRoot()
                    }
                }
            }
            else {
                self.getBackToRoot()
            }
            
            }) { (error) -> Void in
                
                println("Error updating user")
                let alert = SCLAlertView()
                alert.showError("", subTitle: "", closeButtonTitle: "")
                alert.showError("Oups!", subTitle: "Error updating profile. Try again later.", closeButtonTitle: "Ok")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
        
        imgvProfile.image = image
        imageChanged = true
    }
    
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
            self.slLocationField.txtField.text = address
        }
    }
    
    
    //MARK: Private Methods
    func getBackToRoot()
    {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func uploadImage()
    {
        let provider = UploadImageProvider()
        
        let image = imgvProfile.image!
        ProfileViewController.Static.imageData = UIImagePNGRepresentation(image)
    
        provider.uploadProfilePicture(image, success: { (response) -> Void in
            println("Image Uploaded")
            }) { (error) -> Void in
            println("Error uploading image")
        }

    }
    
    func setUpLayout()
    {
        slNameField.setTextField("Name", keyboardType: UIKeyboardType.NamePhonePad, image: UIImage(named: "ic_name"), returnKey: UIReturnKeyType.Next)
        slNameField.txtField.tag = 101
        slNameField.txtField.delegate = self
        
        slEmailField.setTextField("Email", keyboardType: UIKeyboardType.EmailAddress, image: UIImage(named: "ic_email"), returnKey: UIReturnKeyType.Next)
        slEmailField.txtField.tag = 102
        slEmailField.txtField.delegate = self
        
        slLocationField.setTextField("City, Country", keyboardType: nil, image: UIImage(named: "ic_location"), returnKey: UIReturnKeyType.Done)
        slLocationField.txtField.tag = 103
        slLocationField.txtField.delegate = self
        
        btnChangeFavSports.setTitle("Change Fav Sports", forState: UIControlState.Normal)
        btnChangeFavSports.tintColor = UIColor.COLOR_BUTTON_TEXT
        btnChangeFavSports.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND
        btnChangeFavSports.titleLabel?.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 16)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
//        println("Neext")
        
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
