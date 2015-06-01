//
//  DiscoverViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 06/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class DiscoverViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var vwNoLocation: UIView!
    @IBOutlet weak var tblDiscover: UITableView!
    @IBOutlet weak var sliderRadius : HUMSlider!
    @IBOutlet weak var vwSlider : UIView!
    @IBOutlet weak var lblRadius : UILabel!
    @IBOutlet weak var vwTransparentBcgr : UIView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSpace: NSLayoutConstraint!
    
    var valueChanged : Bool = false
    var isLoading : Bool = false
    var usersWithinRadius = [User]()

    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Discover"
        self.setCustomBackButton()
        
        self.setupLayout()
        
        let gestRecognizer = UITapGestureRecognizer(target: self, action: "screenClicked")
        gestRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gestRecognizer)
        
        self.makeRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        super.init(nibName: "DiscoverViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: Reqeust
    func makeRequest(){
        let dist = NSString(format: "%.00f", sliderRadius.value)
        ProfileProvider.getUsersNearby(dist as String, success: { (users) -> Void in
            
            self.isLoading = false
            if !users.isEmpty {
                self.usersWithinRadius = users
                self.tblDiscover.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Fade)
                self.vwNoLocation.hidden = true
            }
            else{
                self.noPeopleNearby()
            }
            }) { (error) -> Void in
            self.isLoading = false
            
            let alert = SCLAlertView()
            alert.showError("Oups!", subTitle: "Error on getting finding people around you. \(error.message.capitalizeFirst)", closeButtonTitle: "Ok")
            
            self.errorOnLoadingPeople()
            
        }
    }
    
    func errorOnLoadingPeople()
    {
        self.vwNoLocation.alpha = 0
        self.vwNoLocation.hidden = false
        self.lblError.text = "We need your location to find people around you. Go to Settings -> Privacy -> Location Services and turn it on. Then reopen the app 😊"
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.vwNoLocation.alpha = 1
        }, completion: nil)
    }
    
    func noPeopleNearby(){
        self.vwNoLocation.alpha = 0 
        self.vwNoLocation.hidden = false
        self.lblError.text = "There's unfortunately no people near you 😢"
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.vwNoLocation.alpha = 1
            }, completion: nil)
    }
    
    //MARK: Button Events
    func radiusClicked() {
        if vwSlider.hidden {
            vwSlider.hidden = false
            
            let scaleX : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            scaleX.fromValue = self.view.frame.width - 5
            scaleX.toValue = 10
            scaleX.springSpeed = 12
            scaleX.springBounciness = 12
            trailingSpace.pop_addAnimation(scaleX, forKey: "scaleConstraint")
            
            let scaleY : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayoutConstraintConstant)
            scaleY.fromValue = 25 
            scaleY.toValue = 100
            scaleY.springSpeed = 12
            scaleY.springBounciness = 12
            heightConstraint.pop_addAnimation(scaleY, forKey: "scaleYConstraint")
            
            self.vwTransparentBcgr.hidden = false
            self.vwTransparentBcgr.alpha = 0
            self.lblRadius.alpha = 0
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.vwTransparentBcgr.alpha = 0.5
                self.lblRadius.alpha = 1
            })

        }
        else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.vwSlider.alpha = 0
                self.vwTransparentBcgr.alpha = 0
                }, completion: { (finished) -> Void in
                    self.vwSlider.hidden = true
                    self.vwSlider.alpha = 1
                    self.vwTransparentBcgr.hidden = true
            })
            if valueChanged {
                //Make New request
                println("Value Changed")
                isLoading = true
                makeRequest()
                valueChanged = false
            }
        }
    }
    
    func screenClicked(){
        if !vwSlider.hidden {
            self.radiusClicked()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if !vwSlider.hidden {
            self.radiusClicked()
        }
    }
    
    @IBAction func sliderValueChanged(slider : UISlider){
        var km : NSString = NSString(format: "%.00f", slider.value)
        lblRadius.text = "Radius: \(km)km"
        valueChanged = true
    }
    
    //MARK: UITableViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblDiscover.dequeueReusableCellWithIdentifier(DiscoverTableViewCell.description(), forIndexPath: indexPath) as! DiscoverTableViewCell
        
        let user = self.usersWithinRadius[indexPath.row]
        cell.lblName.text = user.fullName
        cell.lblCity.text = user.location
        cell.lblScore.text = "Score: \(user.score!)"
        
        let url = (DataProvider.getBaseUrl() + user.imageSmallUrl!)
        
        cell.imgvProfile.sd_setImageWithURL(NSURL(string: url))

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersWithinRadius.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isLoading { return }
        
//        println("Selected row \(indexPath.row)")
        
        let ctrl = PublicProfileViewController()
        ctrl.user = usersWithinRadius[indexPath.row]
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    //MARK: Private Methods
    func setupLayout() {
        self.sliderRadius.tintColor = UIColor.COLOR_BLUE_DARK
        self.sliderRadius.addTarget(self, action: Selector("sliderValueChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        var km : NSString = NSString(format: "%.00f", sliderRadius.value)
        lblRadius.text = "Radius: \(km)km"
        
        //Set left BarButtonItem to Compass
        let backBtn = UIButton(frame: CGRectMake(0, 0, 45, 45))
        backBtn.setTitle(String.fontAwesomeIconWithName(FontAwesome.Compass), forState: UIControlState.Normal)
        backBtn.setTitleColor(UIColor.COLOR_BLUE_DARK, forState: UIControlState.Normal)
        backBtn.titleLabel?.font = UIFont.fontAwesomeOfSize(35)
        backBtn.addTarget(self, action: Selector("radiusClicked"), forControlEvents: UIControlEvents.TouchUpInside)
        let backBtnView = UIView(frame: CGRectMake(0, 0, 45, 45))
        backBtnView.bounds = CGRectOffset(backBtnView.bounds, 3, -2)
        backBtnView.addSubview(backBtn)
        let backButtonItem = UIBarButtonItem(customView: backBtnView)
        self.navigationItem.leftBarButtonItem = backButtonItem
        
        //Register nib for the tableview
        let favSportCell = UINib(nibName: "DiscoverTableViewCell", bundle: nil)
        tblDiscover.registerNib(favSportCell, forCellReuseIdentifier: DiscoverTableViewCell.description())
        
        //Setup the view for the sliderView
        vwSlider.layer.shadowOffset = CGSize(width: 0, height: 0);
        vwSlider.layer.shadowRadius = 7;
        vwSlider.layer.shadowColor = UIColor.blackColor().CGColor
        vwSlider.layer.shadowOpacity = 0.4
        vwSlider.hidden = true

    }
}
