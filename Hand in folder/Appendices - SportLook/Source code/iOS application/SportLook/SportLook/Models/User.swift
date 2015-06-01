//
//  User.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 19/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class User {
    
    var fullName : String?
    var email : String?
    var profileImgURL : String?
    var favSports : [Category]?
    var attendingEvents : [Event]?
    var createdEvents : [Event]?
    var location : String?
    var imageSmallUrl : String?
    var score : Int?
    var id : Int?
    
    var image : NSData?
    
    
    init (json : JSON)
    {
//        println(json)
        if let name = json["name"].string {
            self.fullName = name
        }
        
        if let mail = json["email"].string {
            self.email = mail
        }
        
        if let sports = json["favoriteSports"].array {
            var fSports = [Category]()
            for var i = 0; i < sports.count; i++ {
                fSports.append(Category(json: sports[i]))
            }
            self.favSports = fSports
        }
        
        if let createdSports = json["eventsCreated"].array {
            var cSports = [Event]()
            for var i = 0; i < createdSports.count; i++ {
                cSports.append(Event(json: createdSports[i]))
            }
            self.createdEvents = cSports
        }
        
        if let attendedSports = json["eventsAttending"].array {
            var aSports = [Event]()
            for var i = 0; i < attendedSports.count; i++ {
                aSports.append(Event(json: attendedSports[i]))
                }
            self.attendingEvents = aSports
        }
        
        if let profileImg = json["image"].string {
            self.profileImgURL = profileImg
        }
        
        if let loc = json["address"].string {
            self.location = loc
        }
        
        if let imgSmall = json["image_small"].string {
            self.imageSmallUrl = imgSmall
        }
        
        if let score = json["score"].int {
            self.score = score
        }
        
        if let id = json["id"].int {
            self.id = id
        }

    }
    
    class func getUser() {
        
    }
}
