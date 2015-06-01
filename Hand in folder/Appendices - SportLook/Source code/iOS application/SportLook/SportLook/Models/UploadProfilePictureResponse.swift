//
//  UploadProfilePictureResponse.swift
//  SportLook
//
//  Created by Terminator on 24/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class UploadProfilePictureResponse {
    
    let name: String?
    let address: String?
    let email: String?
    let image: String?
    let imageSmall: String?
    let id: Int?
    let createdAt: String? //probably should be NSDate instead
    let updatedAt: String? ///probably should be NSDate instead
    
    init(dictionary: NSDictionary){
        self.name = dictionary.valueForKey("name") as? String
        self.address = dictionary.valueForKey("address") as? String
        self.email = dictionary.valueForKey("email") as? String
        self.image = dictionary.valueForKey("image") as? String
        self.imageSmall = dictionary.valueForKey("image_small") as? String
        self.id = dictionary.valueForKey("id") as? Int
        self.createdAt = dictionary.valueForKey("createdAt") as? String
        self.updatedAt = dictionary.valueForKey("updatedAt") as? String
    }
}