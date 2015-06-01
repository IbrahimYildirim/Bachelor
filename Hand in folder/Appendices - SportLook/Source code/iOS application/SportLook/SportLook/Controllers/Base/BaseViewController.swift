//
//  BaseViewController.swift
//  SportLook
//
//  Created by Terminator on 28/02/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.navigationBar.translucent = false
    }
    
    func showLoading(message: String, delay: Double) {
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            Utils.performActionWithDelay(seconds: delay) { () -> () in
                SwiftSpinner.show(message, animated: true)
            }
        }
        else {
            MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: message, mode: MRProgressOverlayViewMode.Indeterminate, animated: true, stopBlock: nil)
        }
    }
    
    func hideSpinner(delay: Double) {
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            Utils.performActionWithDelay(seconds: delay) { () -> () in
                SwiftSpinner.hide()
            }
        }
        else {
            MRProgressOverlayView.dismissAllOverlaysForView(self.navigationController?.view, animated: true)
        }
    }
    
    func showCompleted(message: String, delay: Double) {
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            Utils.performActionWithDelay(seconds: delay) { () -> () in
                SwiftSpinner.show(message, animated: false)
            }
        }
        else {
                MRProgressOverlayView.dismissAllOverlaysForView(self.navigationController?.view, animated: true)
        }
        
    }
    
    func showCompletedAndHide(message: String, delay: Double, hideDelay: Double) {
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            Utils.performActionWithDelay(seconds: delay) { () -> () in
                SwiftSpinner.show(message, animated: false)
            }
            
            Utils.performActionWithDelay(seconds: hideDelay) { () -> () in
                SwiftSpinner.hide()
            }
        }
        else {
            MRProgressOverlayView.dismissAllOverlaysForView(self.navigationController?.view, animated: true)
        }
    }
    
    func showCompletedAndHideWithCompletion(message: String, delay: Double, hideDelay: Double, completion: () -> Void) {
        
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0"){
            Utils.performActionWithDelay(seconds: delay) { () -> () in
                SwiftSpinner.show(message, animated: false)
            }
            
            Utils.performActionWithDelay(seconds: hideDelay) { () -> () in
                SwiftSpinner.hide()
                completion()
            }
        }
        else {
            MRProgressOverlayView.dismissAllOverlaysForView(self.navigationController?.view, animated: true)
            completion()
        }
    }
    
    func getNameOfDay (weekday : Int) -> String
    {
        switch weekday {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default :
            return "Day"
        }
    }
}
