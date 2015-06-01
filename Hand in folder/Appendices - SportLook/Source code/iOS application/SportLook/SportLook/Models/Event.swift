//
//  Event.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 20/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class Event : Equatable {
    
    var name : String?
    var image : String?
    var startDate : NSDate?
    var endDate : NSDate?
    var address : String?
    var latitude : Double!
    var longitude : Double!
    var description : String?
    var id: Int?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var createdByMe : Bool?
    var joinedByMe: Bool?
    
    var attending : [User]?
    var category : Category?
    var createdBy: EventHost?
    
    init(json : JSON) {
        
//        println(json)
        
        if let name = json["name"].string {
            self.name = name
        }
        
        if let address = json["address"].string {
            self.address = address
        }
        
        if let latitude = json["lattitude"].double {
            self.latitude = latitude
        }
        
        if let longitude = json["longtitude"].double {
            self.longitude = longitude
        }
        
        if let image = json["image"].string {
            self.image = image
        }
        
        if let createdByMe = json["createdByMe"].bool {
            self.createdByMe = createdByMe
        }
        
        if let joinedByMe = json["joinedByMe"].bool {
            self.joinedByMe = joinedByMe
        }
        
        if let attending = json["attending"].array {
            var attendingPeople = [User]()
            for var i = 0; i < attending.count; i++ {
                attendingPeople.append(User(json: attending[i]))
            }
            self.attending = attendingPeople
        }
        
        if let startDate = json["startTime"].string {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.startDate = dateFormatter.dateFromString(startDate)
        }
        
        if let endTime = json["endTime"].string {
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            self.endDate = df.dateFromString(endTime)
        }
        
        if let description = json["description"].string {
            self.description = description
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
        
        if let category = (Category(json: json["category"])) as Category?{
            self.category = category
        }
        
        if let createdBy = (EventHost(json: json["createdBy"])) as EventHost?{
            self.createdBy = createdBy
        }
        
    }
    
    init(){
        
    }
    
}
func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.name == rhs.name && lhs.id == rhs.id
}
