//
//  FilterEventsViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 09/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class FilterEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allEvents : [Event]!
    var allCategories = [Category]()
    var selectedCategories = [Category]()
    
    var allCategoriesSelected : Bool = SearchEventsViewController.Static.showAllEvents
    
    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Filter Events"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Apply",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("filterEvents"))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: Selector("cancelClicked"))
        
        println("Event counts: \(allEvents?.count)")
        
        self.setupCategories()
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tableView.registerNib(nibName, forCellReuseIdentifier: CategoryTableViewCell.description())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.tableView.alpha = 1
        })
    }
    
    init() {
        super.init(nibName: "FilterEventsViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func filterEvents() {
    
        if allCategoriesSelected == true {
            SearchEventsViewController.Static.showAllEvents = true
        }
        else {
            SearchEventsViewController.Static.filteredCategories = self.selectedCategories
            SearchEventsViewController.Static.showAllEvents = false
        }
        
        SearchEventsViewController.Static.filterEvents = true
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func cancelClicked() {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupCategories()
    {
        allCategories.append(Category.getAllCategory())
        for e in allEvents {
            if !allCategories.contains((e.category)!){
                allCategories.append((e.category)!)
            }
        }
        
        if SearchEventsViewController.Static.showAllEvents {
            self.allCategoriesSelected = true
        }
        else {
            self.selectedCategories = SearchEventsViewController.Static.filteredCategories
        }
    }
    
    //MARK: UITableViewMethods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryTableViewCell.description(), forIndexPath: indexPath) as! CategoryTableViewCell
        
        cell.lblCategory.text = allCategories[indexPath.row].name
        cell.lblIcon.font = UIFont.fontAwesomeOfSize(30)
        
        if allCategoriesSelected {
//            if indexPath.row == 0 {
                cell.lblIcon.textColor = UIColor.COLOR_BLUE_DARK
                cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CheckCircleO)
//            }
//            else if  selectedCategories.contains(self.allCategories[indexPath.row])
//            {
//                cell.lblIcon.textColor = UIColor.COLOR_BLUE_DARK
//                cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CheckCircleO)
//            }
//            else {
////                cell.lblIcon.textColor = UIColor.lightGrayColor()
//                cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleO)
//            }
        } else {
            if selectedCategories.contains(self.allCategories[indexPath.row]){
                cell.lblIcon.textColor = UIColor.COLOR_BLUE_DARK
                cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CheckCircleO)
            }
            else {
                cell.lblIcon.textColor = UIColor.lightGrayColor()
                cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleO)
            }

        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            //All Categories selected
            if !allCategoriesSelected {
                allCategoriesSelected = true
                selectedCategories.removeAll(keepCapacity: false)
                
                for var i = 1; i < allCategories.count; i++ {
                    selectedCategories.append(self.allCategories[i])
                }
            }
            self.tableView.reloadData()
            return
        }
        
        allCategoriesSelected = false
        if !selectedCategories.contains(self.allCategories[indexPath.row]){
            selectedCategories.append(self.allCategories[indexPath.row])
            
            if selectedCategories.count == allCategories.count - 1{
                allCategoriesSelected = true
            }
        } else {
            if selectedCategories.count == 1 {
                return
            }
            selectedCategories.removeAtIndex(find(selectedCategories, allCategories[indexPath.row])!)
        }
        
        self.tableView.reloadData()
    }

}
