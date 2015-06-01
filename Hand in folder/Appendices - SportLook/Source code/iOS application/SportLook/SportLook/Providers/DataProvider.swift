//
//  DataProvider.swift
//  SportLook
//
//  Created by Terminator on 12/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

public enum HttpMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

class DataProvider {
    
    let method: HttpMethod
    let path: String
    let params: [String : AnyObject]
    
    init(method: HttpMethod, path: String, params: [String : AnyObject]){
        self.method = method
        self.path = path
        self.params = params
    }
    
    func requestData(success: (response: JSON) -> Void, failure: (error: Error) -> Void){
        
        Alamofire.manager.request(getHttpMethod(), DataProvider.getBaseUrl() + path, parameters: params)
            .responseJSON {(_, response, JSONObj, error) in
                
                var responseStatusCode: Int = -1
            
                if(error != nil){
                    
                    //Error from Alamofire or non-JSON response from the backend
                    let error = Error(code: String(responseStatusCode), message: "Network couldn't be reached. Try again!")
                    println("Error from Alamofire or not JSON response from the backend")
                    failure(error: error)
                } else if(JSONObj != nil && response != nil){
                    
                    if let statusCode = response?.statusCode {
                        responseStatusCode = statusCode
                    }
                    let json = JSON(JSONObj!)
//                    println(json)
                    //Backend returned an 'error' field
                    if let serverError = json["error"].string {
                        let error = Error(code: String(responseStatusCode), message: serverError)
                        println("Server error: " + serverError)
                        failure(error: error)
                    } else if(responseStatusCode != 200) {
                        //Backend returned status code != 200
                        let error = Error(code: String(responseStatusCode), message: "We're experiencing a technical difficulty current. Try again later!")
                        println("Either request was wrong, either there's a problem with the backend response")
                        failure(error: error)
                    } else {
                        //Actually got the response we want
                        success(response: json)
                    }
                } else {
                    let error = Error(code: "To be set...", message: "Something wrong happened in requestData()")
                    failure(error: error)
                }
        }
    }
    
    func uploadPicture(image: UIImage, success: (response: NSDictionary) -> Void, failure: (error: Error) -> Void) {
        
        let netWrapper = Net(baseUrlString: DataProvider.getBaseUrl())
        netWrapper.POST(path, params: params, successHandler: { responseData in
            
            let response = responseData.json(error: nil)
            if(response != nil){
                let serverError = response?.valueForKey("error") as? String
                if (serverError != nil) {
                    let error = Error(code: "To be set...", message: serverError!)
                    failure(error: error)
                } else{
                    success(response: response!)
                }
            } else{
                let error = Error(code: "To be set...", message: "Couldn't upload image!")
                failure(error: error)
            }
        }, failureHandler: { error in
            let error = Error(code: "To be set...", message: "Something wrong happened in uploadPicture()")
            failure(error: error)
        })
    }
    
    private func getHttpMethod() -> Method{
        
        switch method {
            
        case .GET : return Method.GET
        case .POST: return Method.POST
        case .PUT: return Method.PUT
        case .DELETE: return Method.DELETE
        default : return Method.GET //not sure if best idea
        }
    }
    
    class func getBaseUrl() -> String {
        
        if(Constants.API.useProduction){
            return Constants.API.production;
        }
        return Constants.API.develop;
    }
}