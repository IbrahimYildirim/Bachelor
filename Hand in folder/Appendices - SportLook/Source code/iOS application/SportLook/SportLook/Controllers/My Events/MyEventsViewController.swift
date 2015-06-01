//
//  MyEventsViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 06/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

struct StructMyEvents{
    static var shouldPushEvent = false
    static var eventToPush: Int = 0
}

class MyEventsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblEvents : UITableView!
    @IBOutlet weak var vwEmptyPlaceholder: UIView!
    @IBOutlet weak var lblEmptyPlaceholder: UILabel!

    var myEvents : [Event]?
    
    init() {
        super.init(nibName: "MyEventsViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        let nibName = UINib(nibName: "EventsTableViewCell", bundle: nil)
        tblEvents.registerNib(nibName, forCellReuseIdentifier: EventsTableViewCell.description())
        
        //Opened from push notification 
        if StructMyEvents.shouldPushEvent {
            StructMyEvents.shouldPushEvent = false
            
            let controller = EventInfoViewController()
            controller.eventId = StructMyEvents.eventToPush
            var navController: UINavigationController = UINavigationController(rootViewController: controller)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //TODO: Figure out when to make request instead of everytime
        EventProvider.getMyEvents({ (events) -> Void in

            self.myEvents = events
            //TODO: Show empty placeholder if contains 0 events
            if((self.myEvents)!.count == 0){
                self.vwEmptyPlaceholder.hidden = false
            } else {
                self.vwEmptyPlaceholder.hidden = true
                self.tblEvents.reloadData()
            }
            
        }, failure: { (error) -> Void in
            //do smth with the failure
        })
    }
    
    func setupLayout(){
        
        self.title = "My Events"
        let addBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addClicked"))
        self.navigationItem.rightBarButtonItem = addBtn
        self.setCustomBackButton()

        lblEmptyPlaceholder.textColor = UIColor.COLOR_EMPTY_PLACEHOLDER_LABEL
        vwEmptyPlaceholder.backgroundColor = UIColor.COLOR_EMPTY_PLACEHOLDER_BACKGROUND
    }
    
    //MARK: TableView Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tblEvents.dequeueReusableCellWithIdentifier(EventsTableViewCell.description(), forIndexPath: indexPath) as! EventsTableViewCell
        
        if (myEvents?[indexPath.row].category?.name)! != nil {
            cell.lblCategory.text = Utils.formatSportCategory((myEvents?[indexPath.row].category?.name)!)
        }
        else {
            cell.lblCategory.text = "#category"
        }
        cell.lblName.text = myEvents?[indexPath.row].name
        cell.lblDate.text = Utils.formatDate((myEvents?[indexPath.row].startDate)!)

        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(myEvents != nil){
            return myEvents!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tblEvents.deselectRowAtIndexPath(indexPath, animated: true)
        showEventInfoForEvent(indexPath.row)
    }
    
    func showEventInfoForEvent(number: Int){
        
        let vc = EventInfoViewController()
        if let event = myEvents?[number] {
            vc.eventId = event.id
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Button events
    func addClicked(){
        let navController = UINavigationController(rootViewController: AddEventViewController())
        self.navigationController?.presentViewController(navController, animated: true, completion: nil)
    }
}
