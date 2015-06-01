//
//  ProfileProvider.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 16/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class ProfileProvider {
    
    class func getProfileWithToken(userAccessToken : String, success: (response: User) -> Void, failure: (error: Error) -> Void)
    {
        let profilePath = "/user/profile"
        let params = ["access_token": userAccessToken]
        let dataProvider = DataProvider(method: .GET, path: profilePath, params: params)

        dataProvider.requestData({ (response) -> Void in
            
            let user = User(json: response)
            user.profileImgURL = DataProvider.getBaseUrl() + user.profileImgURL!
//            println("\(user)")
            success(response: user)
            
        }, failure: { (error) -> Void in
            failure(error: error)
            
        })
    }
    
    class func updateProfile(userAccessToken : String, user : User, success : () -> Void, failure: (error: Error) -> Void)
    {
        let path = "/user"
        let params : [String : NSObject] = ["access_token": userAccessToken, "email": user.email!, "name": user.fullName!, "address" : user.location!]
        let dataProvider = DataProvider(method: .PUT, path: path, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            println("User updated")
            success()
        }, failure: { (errorr) -> Void in
            failure(error: errorr)
        })
    }
    
    class func getUsersNearby(distance : String, success : (users : [User]) -> Void, failure : (error : Error) -> Void){
        
        let path = "/user/findUsersWithinRadius"
        let accesToken = KeychainHandler.getUserLoggedToken()!
        let params : [String : AnyObject] = ["access_token" : accesToken, "distance" : distance]
        let dataProvider = DataProvider(method: .GET, path: path, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            if let users = response.array {
                var userArray = [User]()
                if users.count == 0 {
                    success(users: userArray)
                }
                else {
                    for var i = 0; i < users.count; i++ {
                        let user = User(json: users[i])
                        userArray.append(user)
                    }
                    success(users: userArray)
                }
            }
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    class func getPublicProfile(userID : Int!, success : (user : User) -> Void, failure : (error : Error) -> Void) {
        
        let path = "/user/profile"
        let accessToken = KeychainHandler.getUserLoggedToken()!
        let params : [String : AnyObject] = ["access_token" : accessToken, "userId" : userID]
        let dataProvider = DataProvider(method: .GET, path: path, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let user = User(json: response)
            success(user: user)
            
        }, failure: { (error) -> Void in
            
            failure(error: error)
        })
    }
    
    class func updateUserLocation(location : CLLocation, success:() -> Void, failure : (error : Error) -> Void) {
        
        let path = "/user"
        let params : [String : AnyObject] = ["access_token": KeychainHandler.getUserLoggedToken()!, "lattitude" : location.coordinate.latitude, "longtitude" : location.coordinate.longitude]
        let dataProvider = DataProvider(method: .PUT, path: path, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            println("User updated")
            success()
            }, failure: { (errorr) -> Void in
                failure(error: errorr)
        })
    }
}