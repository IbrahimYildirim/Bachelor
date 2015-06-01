//
//  SignupStepTwoViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SignupStepTwoViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblCategories : UITableView!
    @IBOutlet weak var btnFinish: UIButton!
    
    var categories = [Category]()
    var selectedItems = [Category]()
    
    init() {
        super.init(nibName: "SignupStepTwoViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        let nibName = UINib(nibName: "CategoryTableViewCell", bundle: nil)
        tblCategories.registerNib(nibName, forCellReuseIdentifier: CategoryTableViewCell.description())
        
        CategoryProvider.getCategories({ (categories) -> Void in
            self.categories = categories
            self.tblCategories.reloadData()
            }, failure: { (error) -> Void in
                println("failed to get categories")
        })
        
    }

    func setupLayout(){
        
        self.title = "Select Favourite Sports"
        hideBackButton()
        
        self.view.backgroundColor = UIColor.COLOR_VIEW_BACKGROUND
        btnFinish.tintColor = UIColor.COLOR_BUTTON_TEXT
        btnFinish.backgroundColor = UIColor.COLOR_BUTTON_BACKGROUND
        tblCategories.backgroundColor = UIColor.COLOR_FAVORITE_SPORTS_BACKGROUND
    }

    //MARK: UITableView Delegate methods
    
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
    
    func showTabBarController(){
        
        let controller = SportLookTabBarController()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    
    @IBAction func btnFinishTapped(sender: UIButton) {
        
        var selectedCategories = [String]()
        for var i = 0; i < selectedItems.count; i++ {
            selectedCategories.append("\((selectedItems[i].id)!)")
            //println("Selected Items: \(selectedItems[i].name)")
        }
        
        self.showLoading("Setting favourite sports...", delay: 0)
        CategoryProvider.updateCategories(selectedCategories, success: { () -> Void in
            
//            self.hideSpinner(0)
//            self.showTabBarController()

            self.showCompletedAndHideWithCompletion("Favourite sports set!", delay: 0, hideDelay: 1, completion: { () -> Void in
                self.showTabBarController()
            })
            
            }) { (error) -> Void in
                
                println("Error")
                self.hideSpinner(0)
                let alert = SCLAlertView()
                alert.showError("Oups!", subTitle: "An error occured when trying to set your favorite sports. Try again!", closeButtonTitle: "Ok")
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
