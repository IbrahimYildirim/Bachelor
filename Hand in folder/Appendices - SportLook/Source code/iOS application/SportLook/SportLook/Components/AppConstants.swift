//
//  AppConstants.swift
//  SportLook
//
//  Created by Terminator on 19/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

//http://stackoverflow.com/questions/26252233/global-constants-file-in-swift

struct Constants {
    
    struct Facebook {
        static let readPermissions = ["public_profile", "email", "user_location"]
        static let facebookToken = FBSession.activeSession().accessTokenData.accessToken
        static let facebookGraphUrl = "http://graph.facebook.com/"
        static let facebookProfilePicturePath = "/picture?width=640&height=640"
    }
    
    struct API {
        static let production = "http://sheltered-thicket-5729.herokuapp.com"
        static let develop = "http://tranquil-thicket-2116.herokuapp.com"
        static let useProduction = true
    }
    
    struct Load {
        static var searchLoaded  = false
        static var myEventsLoaded = false
        static var profileLoaded = false
        
        static func setScreensToLoad() {
            searchLoaded = false
            myEventsLoaded = false
            profileLoaded = false
        }
        
        static func shouldLoad(string : String) -> Bool {
            
            if string == "search" {
                if !searchLoaded {
                    searchLoaded = true
                    return searchLoaded
                } else {
                    return false
                }
            } else if string == "events" {
                if !myEventsLoaded {
                    myEventsLoaded = true
                    return myEventsLoaded
                } else {
                    return false
                }
            } else if string == "profile" {
                if !profileLoaded {
                    profileLoaded = true
                    return profileLoaded
                } else {
                    return false
                }
            }
            
            return true
        }
    }
    
    struct Parse {
        static let PF_CHAT_CLASS_NAME = "Chat"			//	Class name
        static let PF_CHAT_USER_ID	  = "userId"		//	User ID
        static let PF_CHAT_USER_NAME  = "userName"		//	User Name
        static let PF_CHAT_EVENT_ID	  = "eventId"       //	String
        static let PF_CHAT_MESSAGE    = "message"       //	String
        static let PF_CHAT_CREATED_AT = "createdAt"     //	Date
        static let PF_INSTALLATION_CURRENT_USER_ID = "currrentUserId" // String
        
        static let CHANNELS           = "channels"
        static let CHANNEL_EVENT      = "event_"
        static let CHANNEL_USER       = "user_"
    }
}
