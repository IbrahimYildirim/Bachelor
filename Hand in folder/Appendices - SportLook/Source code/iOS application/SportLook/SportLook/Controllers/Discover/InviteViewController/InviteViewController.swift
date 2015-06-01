//
//  InviteViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 23/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class InviteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var vwNoEvents: UIView!
    @IBOutlet weak var tblEvents: UITableView!
    @IBOutlet weak var lblNoEvents: UILabel!

    var myEvents = [Event]()
    var userID : Int?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Invite to Sport"
        
        let nibName = UINib(nibName: "EventsTableViewCell", bundle: nil)
        tblEvents.registerNib(nibName, forCellReuseIdentifier: EventsTableViewCell.description())
        
        lblNoEvents.textColor = UIColor.COLOR_EMPTY_PLACEHOLDER_LABEL
        vwNoEvents.backgroundColor = UIColor.COLOR_EMPTY_PLACEHOLDER_BACKGROUND
        
        self.showLoading("Loading Events", delay: 0)
        EventProvider.getMyEvents({ (events) -> Void in
            
            self.myEvents = events
            //TODO: Show empty placeholder if contains 0 events
            if(self.myEvents.count == 0){
                self.vwNoEvents.hidden = false
            } else {
                self.vwNoEvents.hidden = true
                self.tblEvents.reloadData()
            }
            self.hideSpinner(0)
            
            }, failure: { (error) -> Void in
                //do smth with the failure
                self.hideSpinner(0)
                let alert = SCLAlertView()
                alert.showError("Failed!", subTitle: "Failed to load your events.", closeButtonTitle: "Ok")

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        super.init(nibName: "InviteViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UITableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblEvents.dequeueReusableCellWithIdentifier(EventsTableViewCell.description(), forIndexPath: indexPath) as! EventsTableViewCell
        
        if (myEvents[indexPath.row].category?.name)! != nil {
            cell.lblCategory.text = Utils.formatSportCategory((myEvents[indexPath.row].category?.name)!)
        }
        else {
            cell.lblCategory.text = "#Category"
        }
        cell.lblName.text = myEvents[indexPath.row].name
        cell.lblDate.text = Utils.formatDate((myEvents[indexPath.row].startDate)!)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if isLoading { return }
        
        if userID != nil {
            self.showLoading("Inviting..", delay: 0)
            let eventID = myEvents[indexPath.row].id!
            EventProvider.inviteToEvent(eventID, userID: userID, success: { (eventActionResponse) -> Void in
                
                self.hideSpinner(0)
                let alert = SCLAlertView()
                alert.addButton("Back to Profile", action: { () -> Void in
                    self.popViewController()
                })
                alert.showSuccess ("Success!", subTitle: "Invite sent.", closeButtonTitle: "OK")
                
            }, failure: { (error) -> Void in
                self.hideSpinner(0)
                let alert = SCLAlertView()
                alert.showError("Failed", subTitle: "Failed to invite, or user already attending event", closeButtonTitle: "OK")
            })
        }
    }
    
    func popViewController (){
        self.navigationController?.popViewControllerAnimated(true)
    }
}
