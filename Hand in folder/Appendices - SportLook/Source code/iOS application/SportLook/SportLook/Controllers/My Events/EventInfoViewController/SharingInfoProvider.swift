//
//  EmailInfoProvider.swift
//  SportLook
//
//  Created by Terminator on 01/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class SharingInfoProvider : UIActivityItemProvider {
    
    var event: Event
    
    init(event: Event){
        self.event = event
        super.init()
    }
    
    override func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        
        //Used only for email
        return "Check this out on SportLook!"
    }
    
    override func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
       
        var message: String
        
        message = ""
        if(activityType == UIActivityTypeMail)
        {
            message = "Hey there, \n \n"
        }
        message += "Check out this " + (event.category?.name)! + " event on SportLook! \n \n"
        message += event.name! + "\n"
        message += "Date & Time: " + Utils.formatDate(event.startDate!) + "\n"
        message += "Address: " + event.address! + "\n \n"
        message += "https://itunes.apple.com/dk/app/move-bizz/id898217295 \n"
        message += "See you there!"
        
        return message;
    }
}