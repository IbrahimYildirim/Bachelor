//
//  KeychainHandler.swift
//  SportLook
//
//  Created by Terminator on 15/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class KeychainHandler {
    
    class func saveUserInfo(token : String, id: String, name: String){
        
        let keychain = Keychain()
        if let error = keychain.set(token, key: "userLoggedToken") {
            println("User token couldn't be saved")
        } else {
            println("Token saved in Keychain: " + token)
        }
        if let error = keychain.set(id, key: "userLoggedId") {
            println("User id couldn't be saved")
        } else {
            println("User id saved in Keychain: " + id)
        }
        if let error = keychain.set(name, key: "userLoggedName") {
            println("User name couldn't be saved")
        } else {
            println("User name saved in Keychain: " + name)
        }
    }
    
    class func clearUserLoggedInfo() {
        
        let keychain = Keychain()
        if let error = keychain.remove("userLoggedToken") {
            println("Couldn't remove user token")
        } else {
            println("Token removed from Keychain")
        }
        if let error = keychain.remove("userLoggedName") {
            println("Couldn't remove user name")
        } else {
            println("User name removed from Keychain")
        }
        if let error = keychain.remove("userLoggedId") {
            println("Couldn't remove user id")
        } else {
            println("User id removed from Keychain")
        }
    }
    
    //MARK: Getters

    class func getUserLoggedToken() -> String? {
    
        let keychain = Keychain()
        let token = keychain.getString("userLoggedToken")
        if token != nil{
//            println("Token retrieved from Keychain: " + token!)
            return token
        } else {
            println("No token found")
            return nil
        }
    }
    
    class func getUserLoggedId() -> String? {
        
        let keychain = Keychain()
        let id = keychain.getString("userLoggedId")
        if id != nil{
//            println("User id retrieved from Keychain: " + id!)
            return id
        } else {
            println("No user id found")
            return nil
        }
    }
    
    class func getUserLoggedName() -> String? {
        
        let keychain = Keychain()
        let name = keychain.getString("userLoggedName")
        if name != nil{
//            println("User name retrieved from Keychain: " + name!)
            return name
        } else {
            println("No user name found")
            return nil
        }
    }
}
