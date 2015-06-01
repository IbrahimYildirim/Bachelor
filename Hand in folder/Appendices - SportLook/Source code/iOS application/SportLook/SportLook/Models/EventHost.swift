//
//  EventHost.swift
//  SportLook
//
//  Created by Terminator on 01/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class EventHost {
    
    var name: String?
    var address: String?
    var email: String?
    var image: String?
    var imageSmall: String?
    var id: Int?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    init(){
        
    }
    
    init(json : JSON) {
        
        if let name = json["name"].string {
            self.name = name
        }
        
        if let address = json["address"].string {
            self.address = address
        }
        
        if let email = json["email"].string {
            self.email = email
        }
        
        if let image = json["image"].string {
            self.image = image
        }
        
        if let imageSmall = json["imageSmall"].string {
            self.imageSmall = imageSmall
        }
        
        if let id = json["id"].int {
            self.id = id
        }
        
        if let createdAt = json["createdAt"].string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.createdAt = dateFormatter.dateFromString(createdAt)
        }
        
        if let updatedAt = json["updatedAt"].string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.updatedAt = dateFormatter.dateFromString(updatedAt)
        }
    }
    
}