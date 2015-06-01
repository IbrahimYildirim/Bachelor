//
//  ChangeFavSportsViewController.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 10/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class ChangeFavSportsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories = [Category]()
    var selectedItems = [Category]()
    
    @IBOutlet weak var tblCategories : UITableView!
    
    
    //MARK: Utilities
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Fav. Sports"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: Selector("updateClicked"))
        
//        self.setCustomBackButton()
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tblCategories.registerNib(nibName, forCellReuseIdentifier: CategoryTableViewCell.description())
        
        CategoryProvider.getCategories({ (categories) -> Void in
            self.categories = categories
            self.tblCategories.reloadData()
        }, failure: { (error) -> Void in
            println("failed to get categories")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init() {
        super.init(nibName: "ChangeFavSportsViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Buttons Events 
    func updateClicked() {
        
        var selectedCategories = [String]()
        for var i = 0; i < selectedItems.count; i++ {
            selectedCategories.append("\((selectedItems[i].id)!)")
//            println("Selected Items: \(selectedItems[i].name)")
        }
        
        self.showLoading("Updating Sports", delay: 0)
        CategoryProvider.updateCategories(selectedCategories, success: { () -> Void in
            
            self.hideSpinner(0)
            self.backToProfile()
            
        }) { (error) -> Void in
            
            println("Error")
            self.hideSpinner(0)
            let alert = SCLAlertView()
            alert.showError("Oups!", subTitle: "An error occured when trying to upgrade your favorite sports.", closeButtonTitle: "Ok")
        }
    }
    
    func backToProfile(){
        
        ProfileViewController.Static.userChanged = true
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: UITableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CategoryTableViewCell.description(), forIndexPath: indexPath) as! CategoryTableViewCell
        
        cell.lblCategory.text = categories[indexPath.row].name
        
        if selectedItems.contains(categories[indexPath.row]){
            cell.lblCategory.textColor = UIColor.COLOR_BLUE_DARK;
            cell.lblCategory.font = UIFont(name: UIFont.QUICKSAND_BOLD, size: 17)
            
            cell.lblIcon.textColor = UIColor.COLOR_BLUE_DARK
            cell.lblIcon.font = UIFont.fontAwesomeOfSize(25)
            cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CheckCircleO)
//            cell.lblIcon.transform = CGAffineTransformMakeScale(1.2, 1.2)
        }
        else {
            cell.lblCategory.textColor = UIColor.darkGrayColor();
            cell.lblCategory.font = UIFont(name: UIFont.QUICKSAND_REGULAR, size: 17)
            
            cell.lblIcon.textColor = UIColor.lightGrayColor()
            cell.lblIcon.font = UIFont.fontAwesomeOfSize(20)
            cell.lblIcon.text = String.fontAwesomeIconWithName(FontAwesome.CircleO)
//            cell.lblIcon.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tblCategories.cellForRowAtIndexPath(indexPath) as! CategoryTableViewCell
        
        if !contains(selectedItems, categories[indexPath.row])
        {
            scaleView(cell.lblIcon)
            selectedItems.append(categories[indexPath.row])
            tblCategories.reloadData()
        }
        else {
            var index = -1
            for var i = 0; i < selectedItems.count; ++i {
                if selectedItems[i].name == categories[indexPath.row].name{
                    index = i
                }
            }
            
            if index != -1 {
                shrinkView(cell.lblIcon)
                selectedItems.removeAtIndex(index)
                tblCategories.reloadData()
            }
        }
    }

    //MARK: Animations
    func scaleView(view : UIView)
    {
        let scaleAnimation : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springSpeed = 12
        scaleAnimation.springBounciness = 12
        scaleAnimation.toValue = NSValue(CGSize: CGSize(width: 1.2, height: 1.2))
        view.layer.pop_addAnimation(scaleAnimation, forKey: "scaleUp");
    }
    
    func shrinkView(view : UIView)
    {
        let scaleAnimation : POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation.springSpeed = 12
        scaleAnimation.springBounciness = 12
        scaleAnimation.toValue = NSValue(CGSize: CGSize(width: 1.0, height: 1.0))
        view.layer.pop_addAnimation(scaleAnimation, forKey: "scaleUp");
    }
}
