//
//  ParseChannelsHandler.swift
//  SportLook
//
//  Created by Terminator on 27/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class ParseChannelsHandler {
    
    class func subscribeToEventChannel(eventId: String){
        //User subscribes to the event channel for Push notifications (for the Chat)
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(eventId, forKey: Constants.Parse.CHANNELS)
        currentInstallation.saveInBackground()
    }
    
    class func unsubscribeFromEventChannel(eventId: String){
        //User unsubscribes from the event channel for Push notifications (for the Chat)
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject(eventId, forKey: Constants.Parse.CHANNELS)
        currentInstallation.saveInBackground()
    }
    
    class func subscribeToUserChannel(userId: String){
        //Subscribe to user channel for Push notifications (invite to event)
        let userId = Constants.Parse.CHANNEL_USER + KeychainHandler.getUserLoggedId()!
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(userId, forKey: Constants.Parse.CHANNELS)
        currentInstallation.saveInBackground()
    }
    
    class func unsubscribeFromUserChannel(userId: String){
        //Unsubscribe from user channel for Push notifications (invite to event)
        let userId = Constants.Parse.CHANNEL_USER + KeychainHandler.getUserLoggedId()!
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.removeObject(userId, forKey: Constants.Parse.CHANNELS)
        currentInstallation.saveInBackground()
    }
}