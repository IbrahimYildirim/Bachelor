//
//  LoginResponse.swift
//  SportLook
//
//  Created by Terminator on 17/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class LoginResponse {
    
    let accessToken: String?
    let userId: Int?
    let userName: String?
    
    init(json: JSON){
        
        //TODO: Map the rest of the fields returned

        if let token = json["access_token"].string {
            self.accessToken = token
        }
        else {
            self.accessToken = nil
        }
        
        if let userId = json["id"].int {
            self.userId = userId
        }
        else {
            self.userId = nil
        }
        
        if let userName = json["name"].string {
            self.userName = userName
        }
        else {
            self.userName = nil
        }
    }
}