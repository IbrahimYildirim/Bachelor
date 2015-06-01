//
//  SignupStepTwoViewController.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class SignupStepTwoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblCategories : UITableView!
    
    var items: [String] = ["We", "Are", "Family"]

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tblCategories.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.tblCategories.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override init() {
        super.init(nibName: "SignupStepTwoViewController", bundle: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell : UITableViewCell = self.tblCategories.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        println("You selected cell #\(indexPath.row)")
    }
    
}
