//
//  PublicProfileViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 20/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class PublicProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    //MARK: Layout Variables
    @IBOutlet weak var imgvProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblFavIcon: UILabel!
    @IBOutlet weak var lblInviteIcon: UILabel!
    @IBOutlet weak var tblAttendingEvents: UITableView!
    @IBOutlet weak var tblFavSports: UITableView!
    @IBOutlet weak var vwFavSports : UIView!
    @IBOutlet weak var actvIndicator : UIActivityIndicatorView!
    @IBOutlet weak var vwNoEvents : UIView!
    @IBOutlet weak var lblNoEvents : UILabel!
    @IBOutlet weak var vwNoFavSports: UIView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    //MARK: Variables
    var user : User!
    var favSportsIShown : Bool = false
    var favSports = [Category]()
    var attendingEvents = [Event]()
    var didAnimate = false
    
    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Discover"
        self.setCustomBackButton()
        
        if user != nil {
            setupUser()
        }
        
        //Setup FA Icons
        lblFavIcon.font = UIFont.fontAwesomeOfSize(35)
        lblFavIcon.text = String.fontAwesomeIconWithName(FontAwesome.Heart)
        lblInviteIcon.font = UIFont.fontAwesomeOfSize(35)
        lblInviteIcon.text = String.fontAwesomeIconWithName(FontAwesome.UserPlus)
        
        //Set up shadow on Fav Sports Bubble
        vwFavSports.layer.shadowOffset = CGSize(width: 0, height: 1);
        vwFavSports.layer.shadowRadius = 10;
        vwFavSports.layer.shadowColor = UIColor.blackColor().CGColor
        vwFavSports.layer.shadowOpacity = 0.4
        
        let gestRecognizer = UITapGestureRecognizer(target: self, action: "screenClicked")
        gestRecognizer.cancelsTouchesInView = false
        gestRecognizer.delegate = self
        self.view.addGestureRecognizer(gestRecognizer)
        
        let favSportCell = UINib(nibName: "FavSportsTableViewCell", bundle: nil)
        tblFavSports.registerNib(favSportCell, forCellReuseIdentifier: FavSportsTableViewCell.description())
        
        let eventCell = UINib(nibName: "AttendedEventTableViewCell", bundle: nil)
        tblAttendingEvents.registerNib(eventCell, forCellReuseIdentifier: AttendedEventTableViewCell.description())
        
        let eventHeaderCell = UINib(nibName: "EventTableHeader", bundle: nil)
        tblAttendingEvents.registerNib(eventHeaderCell, forHeaderFooterViewReuseIdentifier: EventTableHeader.description())
        
        getFullUserInfo()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.imgvProfile.layer.cornerRadius = self.imgvProfile.frame.size.width / 2
        self.imgvProfile.clipsToBounds = true
        self.imgvProfile.layer.borderWidth = 2.0
        self.imgvProfile.layer.borderColor = UIColor.COLOR_PROFILE_PHOTO_BORDER.CGColor
        
        
        if didAnimate { return }
        
        UIView.animateWithDuration (0.3, animations: { () -> Void in
            self.imgvProfile.alpha = 1
        })
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            let scaleAnimation : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
            scaleAnimation.springSpeed = 12
            scaleAnimation.springBounciness = 12
            scaleAnimation.fromValue = NSValue(CGSize: CGSize(width: 0, height: 0))
            self.imgvProfile.layer.pop_addAnimation(scaleAnimation, forKey: "scaleUp");
        }
        didAnimate = true
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !didAnimate {
            self.imgvProfile.alpha = 0 
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        super.init(nibName: "PublicProfileViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: User Methods
    func setupUser(){
        
        if user.profileImgURL != nil {
            let url = NSURL(string: DataProvider.getBaseUrl() + user.profileImgURL!)
            imgvProfile.sd_setImageWithURL(url)
        }
        
        if user.fullName != nil {
            lblName.text = user.fullName
        }
        
        if user.location != nil {
            lblLocation.text = user.location
        }
    }
    
    func getFullUserInfo() {
        if self.user != nil {
            ProfileProvider.getPublicProfile(user.id!, success: { (user) -> Void in
                
                self.fadeOut(self.actvIndicator)
                
                self.attendingEvents = user.attendingEvents!
                self.favSports = user.favSports!
                
                self.updateUser()
                }, failure: { (error) -> Void in
                    println("Failed to get User")
            })
        }
    }
    
    func updateUser() {
        if favSports.count > 0 {
            tblFavSports.reloadData()
            self.vwNoFavSports.hidden = true
        }
        else {
            self.fadeIn(self.vwNoFavSports)
        }
        
        if attendingEvents.count > 0 {
            tblAttendingEvents.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
            self.vwNoEvents.hidden = true
        }
        else {
            self.vwNoEvents.hidden = false
            self.lblNoEvents.text = "\(user.fullName!) is not attending any upcomming events."
        }
    }
    
    //MARK: UITableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == tblAttendingEvents
        {
            let cell = tblAttendingEvents.dequeueReusableCellWithIdentifier(AttendedEventTableViewCell.description(), forIndexPath: indexPath) as! AttendedEventTableViewCell
            
            let event = attendingEvents[indexPath.row]
            
            if event.category?.name != nil {
                cell.lblCategory.text = "#\((event.category?.name)!)"
            } else {
                cell.lblCategory.text = "#Category"
            }
            
            if event.name != nil {
                cell.lblName.text = event.name
            } else {
                cell.lblName.text = "Event Name"
            }
            
            if event.address != nil {
                cell.lblCity.text = event.address
            } else {
                cell.lblCity.text = "Address"
            }
            
            if event.startDate != nil {
                let df = NSDateFormatter()
                df.dateFormat = "dd. MMM"
                cell.lblDate.text = df.stringFromDate(event.startDate!)
            } else {
                cell.lblDate.text = "dd. MMM"
            }
            
            
            return cell
        }
            
        else
        {
            let cell = tblFavSports.dequeueReusableCellWithIdentifier(FavSportsTableViewCell.description(), forIndexPath: indexPath) as! FavSportsTableViewCell
            
            let category = self.favSports[indexPath.row]
            
            if category.name != nil {
                cell.lblCategory.text = "#\(category.name!)"
            } else {
                cell.lblCategory.text = "#Category"
            }
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblAttendingEvents {
            return self.attendingEvents.count
        }
        else {
            return self.favSports.count
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblAttendingEvents {
            let headerCell = tblAttendingEvents.dequeueReusableHeaderFooterViewWithIdentifier(EventTableHeader.description()) as! EventTableHeader
            
            return headerCell
        }
        else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblAttendingEvents {
            return 30
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if favSportsIShown {
            hideFavSports()
            favSportsIShown = false
            return
        }
        
        let ctrl = EventInfoViewController()
        let selectedEvent = attendingEvents[indexPath.row]
        ctrl.eventId = selectedEvent.id
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

    //MARK: Button Events
    @IBAction func favSportsClicked(sender: AnyObject) {
        if favSportsIShown {
            hideFavSports()
            favSportsIShown = false
        }
        else {
            showFavSports(sender)
            favSportsIShown = true
        }
    }
    
    @IBAction func inviteClicked(sender: AnyObject) {
        
        let ctrl = InviteViewController()
        ctrl.userID = self.user.id!
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    func screenClicked()
    {
        if favSportsIShown {
            hideFavSports()
            favSportsIShown = false
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if touch.view == btnFavorite {
            return false
        }
        else {
            return true
        }
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
