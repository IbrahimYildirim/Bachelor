//
//  CategoryProvider.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 23/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class CategoryProvider {


    class func getCategories(success:(categories : [Category]) -> Void, failure:(error : Error) -> Void) {
    
        let categoryPath = "/sport"
        let params = ["access_token": KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: categoryPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            var categories = [Category]()
            if let json = response["sports"].array {
                
                for var i = 0; i < json.count; i++ {
                    let category : JSON = json[i]
                    
                    if let catname = category["name"].string {
                        categories.append(Category(json: json[i]))
                    }
                }
            }
            
            success(categories: categories)
            
            println("Number of categories: \(categories.count)")
            
            
        }, failure: { (error) -> Void in
            
            failure(error: error)
            
        })
    }
    
    class func updateCategories(categories : [String], success:() -> Void, failure : (error : Error) -> Void){
        
        let path = "/sport"
        let params : [String : NSObject]  = ["access_token" : KeychainHandler.getUserLoggedToken()!, "sports" : categories]
        let dataProvider = DataProvider(method: .POST, path: path, params: params)
        
//        println(categories)
//        println(params)

        dataProvider.requestData({ (response) -> Void in
            println("Saved new categories")
            success()
        }, failure: { (errorr) -> Void in
            failure(error: errorr)
        })
    }
    
}