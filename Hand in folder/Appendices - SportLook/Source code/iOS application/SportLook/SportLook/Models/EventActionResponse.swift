//
//  EventActionResponse.swift
//  SportLook
//
//  Created by Terminator on 01/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class EventActionResponse {
    
    var message: String?
    
    init(){
        
    }
    
    init(json : JSON) {
        
        if let message = json["message"].string {
            self.message = message
        }
    }
}