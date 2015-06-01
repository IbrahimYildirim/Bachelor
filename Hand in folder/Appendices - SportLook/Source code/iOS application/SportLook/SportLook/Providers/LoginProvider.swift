//
//  LoginProvider.swift
//  SportLook
//
//  Created by Terminator on 13/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class LoginProvider {

    let loginPath = "/login"
    let facebookLoginPath = "/facebooklogin"
    let registerPath = "/register"
    let registerWithFacebookPath = "/facebook"
    let uploadProfilePicturePath = "/user/uploadImage"
    
    func login(email: String, password: String, success: (response: LoginResponse) -> Void, failure: (error: Error) -> Void){
        
        let params = ["email": email, "password": password]
        let dataProvider = DataProvider(method: .POST, path: loginPath, params: params)
        dataProvider.requestData({ (response) -> Void in
            
            let loginResponse = LoginResponse(json: response)
            self.postLoginOrSignUpAction(loginResponse)
            
            success(response: loginResponse)
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    func loginWithFacebook(email: String, facebookToken: String, success: (response: LoginResponse) -> Void, failure: (error: Error) -> Void){
        
        let params = ["email": email, "facebook_token": facebookToken]
        let dataProvider = DataProvider(method: .POST, path: facebookLoginPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let loginResponse = LoginResponse(json: response)
            self.postLoginOrSignUpAction(loginResponse)
            
            success(response: loginResponse)
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    func signup(email: String, password: String, name: String, address: String, success: (response: LoginResponse) -> Void, failure: (error: Error) -> Void){
        
        let params = ["email": email, "password": password, "name": name, "address": address]
        let dataProvider = DataProvider(method: .POST, path: registerPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let loginResponse = LoginResponse(json: response)
            self.postLoginOrSignUpAction(loginResponse)
            
            success(response: loginResponse)
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    func signupWithFacebook(email: String, name: String, address: String, facebookToken: String, success: (response: LoginResponse) -> Void, failure: (error: Error) -> Void){
        
        let params = ["email": email, "name": name, "address": address, "facebook_token": facebookToken]
        let dataProvider = DataProvider(method: .POST, path: registerWithFacebookPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let loginResponse = LoginResponse(json: response)
            self.postLoginOrSignUpAction(loginResponse)
            
            success(response: loginResponse)
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    private func postLoginOrSignUpAction(loginResponse: LoginResponse){
        
        KeychainHandler.saveUserInfo(loginResponse.accessToken!, id: String(loginResponse.userId!), name: loginResponse.userName!)
        
        //Setup userId for Parse
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation[Constants.Parse.PF_INSTALLATION_CURRENT_USER_ID] = KeychainHandler.getUserLoggedId()
        currentInstallation.saveInBackground()
        
        //Subscribe to user channel for Push notifications (invite to event)
        let userId = Constants.Parse.CHANNEL_USER + KeychainHandler.getUserLoggedId()!
        ParseChannelsHandler.subscribeToUserChannel(userId)
    }
}
