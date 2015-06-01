//
//  ProfileViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 02/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit



class ProfileViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    struct Static {
        static var userChanged = false
        static var imageChanged = false
        static var imageData = UIImagePNGRepresentation(UIImage(named: "placeholder_profile_image"))
    }
    
    @IBOutlet weak var tblEvents : UITableView!
    @IBOutlet weak var tblFavSports : UITableView!
    @IBOutlet weak var vwFavSports : UIView!
    @IBOutlet weak var iconFav : UILabel!
    @IBOutlet weak var iconSettings : UILabel!
    @IBOutlet weak var vwNoFavSports : UIView!
    @IBOutlet weak var vwNoAttendedEvents : UIView!
    
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblCity : UILabel!
    @IBOutlet weak var imgvProfilePlaceholder : UIImageView!
    
    var favSports = [Category]()
    var userEvents = [Event]()
    
    var favSportsIShown : Bool = false
    var userLoaded : Bool = false
    var loadedImg : Bool = false
    var user : User?

    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomBackButton()

        let eventCell = UINib(nibName: "AttendedEventTableViewCell", bundle: nil)
        tblEvents.registerNib(eventCell, forCellReuseIdentifier: AttendedEventTableViewCell.description())
        
        let eventHeaderCell = UINib(nibName: "EventTableViewCellHeader", bundle: nil)
        tblEvents.registerNib(eventHeaderCell, forCellReuseIdentifier: EventTableViewCellHeader.description())
        
        let favSportCell = UINib(nibName: "FavSportsTableViewCell", bundle: nil)
        tblFavSports.registerNib(favSportCell, forCellReuseIdentifier: FavSportsTableViewCell.description())
        
        //Load FA icons
        iconFav.font = UIFont.fontAwesomeOfSize(35)
        iconFav.text = String.fontAwesomeIconWithName(FontAwesome.Heart)
        
        iconSettings.font = UIFont.fontAwesomeOfSize(35)
        iconSettings.text = String.fontAwesomeIconWithName(FontAwesome.Cog)
        
        //Set up shadow on Fav Sports Bubble
        vwFavSports.layer.shadowOffset = CGSize(width: 0, height: 1);
        vwFavSports.layer.shadowRadius = 10;
        vwFavSports.layer.shadowColor = UIColor.blackColor().CGColor
        vwFavSports.layer.shadowOpacity = 0.4
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "screenClicked"))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.translatesAutoresizingMaskIntoConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Make Profile Image Round
        imgvProfilePlaceholder.layer.cornerRadius = imgvProfilePlaceholder.frame.size.width / 2
        imgvProfilePlaceholder.clipsToBounds = true
        imgvProfilePlaceholder.layer.borderWidth = 2.0
        imgvProfilePlaceholder.layer.borderColor = UIColor.COLOR_PROFILE_PHOTO_BORDER.CGColor
        
        let shouldLoad = Constants.Load.shouldLoad("profile")
        println("UserLoaded: \(self.userLoaded) \n Static.UserChanged: \(Static.userChanged)\n Constant.shouldLoad: \(shouldLoad)")
        
        if !userLoaded || Static.userChanged || Constants.Load.shouldLoad("profile") {

            self.showLoading("Loading Profile", delay: 0)
            
            ProfileProvider.getProfileWithToken(KeychainHandler.getUserLoggedToken()!, success: { (user) -> Void in
                
                self.user = user
                self.updateUser()
                self.userLoaded = true
                Static.userChanged = false
                
                self.hideSpinner(0)
                
                }) { (error) -> Void in
                    println(error)
                    println("Error Loading Profile")

                    self.hideSpinner(0) //Remove loading screen
                    let alert = SCLAlertView()
                    alert.showError("Oups!", subTitle: "Error loading Profile. Try again later.", closeButtonTitle: "Ok")
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if favSportsIShown {
            hideFavSports()
            favSportsIShown = !favSportsIShown
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        super.init(nibName: "ProfileViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    func updateUser() {
        
        if self.user == nil {
            return
        }
        
        if self.user?.fullName != nil {
            lblName.text = user?.fullName?.capitalizeFirst
        }
        
        
        if self.user?.location != nil {
            lblCity.text = user?.location
        }
        
        
        if Static.imageChanged {
            let image = UIImage(data: Static.imageData)
            self.imgvProfilePlaceholder.image = image
            self.user?.image = Static.imageData
            Static.imageChanged = false
        }
        else if user?.profileImgURL != nil && !loadedImg {

            var url = NSURL(string: (user?.profileImgURL)!)
            SDWebImageDownloader.sharedDownloader().downloadImageWithURL(url, options: nil, progress: nil, completed: {(image: UIImage?, data: NSData?, error: NSError?, finished: Bool) in
                if (image != nil) {
                    
                    self.imgvProfilePlaceholder.alpha = 0.0
                    UIView.transitionWithView(self.imgvProfilePlaceholder, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
                        self.imgvProfilePlaceholder.image = image
                        self.imgvProfilePlaceholder.alpha = 1
                    }, completion: nil)
                    
                    self.loadedImg = true
                }
            })
        }
        
        if user?.favSports?.count == 0 || user?.favSports == nil {
            vwNoFavSports.hidden = false
        }
        else {
            favSports = (user?.favSports)!
            tblFavSports.reloadData()
            vwNoFavSports.hidden = true
        }
        
        if user?.attendingEvents?.count == 0 {
            vwNoAttendedEvents.hidden = false
        }
        else {
            vwNoAttendedEvents.hidden = true
            userEvents = (user?.attendingEvents)!
            tblEvents.reloadData()
        }
        
    }
    
    //MARK: UITableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //Event Table
        if tableView == tblEvents
        {
            let cell = tblEvents.dequeueReusableCellWithIdentifier(AttendedEventTableViewCell.description(), forIndexPath: indexPath) as! AttendedEventTableViewCell
            
            let event = userEvents[indexPath.row]
            
            cell.lblCategory.text = "#\((event.category?.name)!)"
            cell.lblName.text = event.name
            cell.lblCity.text = event.address
            
            let df = NSDateFormatter()
            df.dateFormat = "dd. MMM"
            cell.lblDate.text = df.stringFromDate(event.startDate!)
            
            return cell
        }
        
        else
        {
            let cell = tblFavSports.dequeueReusableCellWithIdentifier(FavSportsTableViewCell.description(), forIndexPath: indexPath) as! FavSportsTableViewCell
            
            cell.lblCategory.text = "#\(favSports[indexPath.row].name!)"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblEvents {
            return userEvents.count
        }
        else {
            return favSports.count
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == tblEvents {
            let headerCell = tblEvents.dequeueReusableCellWithIdentifier(EventTableViewCellHeader.description()) as! EventTableViewCellHeader
            headerCell.lblHeaderName.text = "Attending Events"
            
            return headerCell
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblEvents {
            return 30
        }
        else {
            return 0
        }
    }
    
    //MARK: Click Events
    func screenClicked()
    {
        if favSportsIShown {
            hideFavSports()
            favSportsIShown = false
        }
    }
    
    @IBAction func onClickFavSports(sender: AnyObject) {
//        println("Fav Sports Clicked")
        
        if favSportsIShown {
            hideFavSports()
        }
        else {
            showFavSports(sender)
        }
        
        favSportsIShown = !favSportsIShown
    }
    
    @IBAction func editClicked(sender: AnyObject) {
        
        if !userLoaded {
            return
        }
        
        let controller = EditProfileViewController()
        self.user?.image = UIImagePNGRepresentation(self.imgvProfilePlaceholder.image)
        controller.user = user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //MARK: Animations
    func hideFavSports()
    {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.vwFavSports.alpha = 0
            }, completion: { (finished) -> Void in
                self.vwFavSports.hidden = true
                self.vwFavSports.alpha = 1
        })
    }
    
    func showFavSports(button: AnyObject)
    {
        vwFavSports.hidden = false
        vwFavSports.center = button.center
        
        let scaleAnimation : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springSpeed = 12
        scaleAnimation.springBounciness = 12
        scaleAnimation.fromValue = NSValue(CGSize: CGSize(width: 0, height: 0))
        vwFavSports.layer.anchorPoint = CGPoint(x: 0, y: 0.5);
        vwFavSports.layer.pop_addAnimation(scaleAnimation, forKey: "scaleUp");
        
    }

}
