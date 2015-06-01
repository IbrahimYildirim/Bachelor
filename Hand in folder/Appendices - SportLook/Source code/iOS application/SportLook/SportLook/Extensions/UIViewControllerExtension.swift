//
//  UIViewControllerExtension.swift
//  SportLook
//
//  Created by Terminator on 01/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //Scenario: A opens B
    //Set this in A to hide it in B
    func setCustomBackButton() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: UIBarButtonItemStyle.Plain,
            target: nil,
            action: nil)
    }
    
    func hideBackButton() {
        self.navigationItem.hidesBackButton = true
    }
    
    func SYSTEM_VERSION_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    func SYSTEM_VERSION_GREATER_THAN(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
    
    func fadeOut(view : UIView)
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.alpha = 0.0
        }) { (bool) -> Void in
            view.hidden = true
        }
    }
    
    func fadeIn(view : UIView)
    {
        view.hidden = false
        view.alpha = 0.0
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            view.alpha = 1.0
            }) { (bool) -> Void in
        }
    }
    
    
    
}

