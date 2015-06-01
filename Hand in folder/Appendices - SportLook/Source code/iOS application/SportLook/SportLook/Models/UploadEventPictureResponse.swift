//
//  UploadEventPictureResponse.swift
//  SportLook
//
//  Created by Terminator on 03/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class UploadEventPictureResponse {
    
    let image: String?
    
    init(dictionary: NSDictionary){
        self.image = dictionary.valueForKey("image") as? String
    }
    
    //TODO: Check what is the real response and change the model
}