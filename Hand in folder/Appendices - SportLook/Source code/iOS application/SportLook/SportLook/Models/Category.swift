//
//  Category.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 20/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation


class Category : Equatable {
    
    var name : String?
    var id : Int?
    var createdAt: NSDate?//check
    var updatedAt: NSDate?//check
    
    init(json : JSON) {
        
        if let name = json["name"].string {
            self.name = name
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
    
    init() {
        
    }
    
    init(name : String, id : Int) {
        self.name = name
        self.id = id
    }
    
    class func getAllCategory() -> Category {
        let cat = self.init(name: "All Categories", id: -1)
        return cat
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    return lhs.name == rhs.name && lhs.id == rhs.id
}