//
//  EventProvider.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 27/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class EventProvider {
    
    class func getEvents(success:(event : [Event])->Void, failure:(error : Error) -> Void) {
        
        let eventPath = "/event"
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: eventPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            if let eventsResponse = response.array {
            
                var events = [Event]()
                for var i = 0; i < eventsResponse.count; i++ {
                    
                    let event : JSON = eventsResponse[i]
                    if let eventName = event["name"].string {
                        // FIXME:  Figure out a better way of checking instead of just for "name"
                        events.append(Event(json: event))
                    }
                }
                success(event: events)
            } else {
                println("getEvents didn't return an array")
            }
            
        }, failure: { (errorr) -> Void in
            println(errorr)
            failure(error: errorr)
        })
    }
    
    class func getMyEvents(success:(events : [Event]) -> Void, failure:(error : Error) -> Void) {
        
        let eventPath = "/event"
        let subPath = "/myevents"
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: eventPath + subPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            if let myEventsResponse = response.array {
                
                var events = [Event]()
                for event in myEventsResponse {
                    if let eventName = event["name"].string {
                        // FIXME:  Figure out a better way of checking instead of just for "name"
                        events.append(Event(json: event))
                    }
                }
                success(events: events)
            }
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    class func getEvent(eventId: String, success:(response : Event) -> Void, failure:(error : Error) -> Void){
        
        let eventPath = "/event"
        let subPath = "/" + eventId
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: eventPath + subPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let event = Event(json: response)
            success(response: event)
            
        }, failure: { (error) -> Void in
            failure(error: error)
        })
        
    }

    class func addEvent(event : Event, success:(e : Event) -> Void, failure:(error : Error) -> Void){
    
        let eventPath = "/event"
        var params : [String : AnyObject] = ["access_token" : KeychainHandler.getUserLoggedToken()!, "name" : event.name!]
        params.updateValue(event.address!, forKey: "address")
        params.updateValue("\((event.category?.id)!)", forKey: "category")
        
        if event.description != nil {params.updateValue(event.description!, forKey: "description")}
        if event.latitude != nil {params.updateValue(event.latitude!, forKey: "lattitude")}
        if event.longitude != nil {params.updateValue(event.longitude!, forKey: "longtitude")}
        
        //Format and update the date
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startDate = dateFormatter.stringFromDate(event.startDate!)
        params.updateValue(startDate, forKey: "startTime")
        if event.endDate != nil {
            let endDate = dateFormatter.stringFromDate(event.endDate!)
            params.updateValue(endDate, forKey: "endTime")
        }
        else {
            params.updateValue(startDate, forKey: "endTime")
        }
        
        let dataProvider = DataProvider(method: .POST, path: eventPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            success(e: Event(json: response))
        }, failure: { (errorr) -> Void in
            failure(error: errorr)
        })
    }
    
    class func updateEvent(event : Event!, success:() -> Void, failure:(error : Error) -> Void)
    {
        if event.id != nil {
            let eventPath = "/event/\(event.id!)"
            var params : [String : AnyObject] = ["access_token" : KeychainHandler.getUserLoggedToken()!, "name" : event.name!]
            params.updateValue(event.address!, forKey: "address")
            params.updateValue("\((event.category?.id)!)", forKey: "category")
            
            if event.description != nil {params.updateValue(event.description!, forKey: "description")}
            if event.latitude != nil {params.updateValue(event.latitude!, forKey: "lattitude")}
            if event.longitude != nil {params.updateValue(event.longitude!, forKey: "longtitude")}
            
            //Format and update the date
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDate = dateFormatter.stringFromDate(event.startDate!)
            params.updateValue(startDate, forKey: "startTime")
            if event.endDate != nil {
                let endDate = dateFormatter.stringFromDate(event.endDate!)
                params.updateValue(endDate, forKey: "endTime")
            }
            else {
                params.updateValue(startDate, forKey: "endTime")
            }
            
            let dataProvider = DataProvider(method: .PUT, path: eventPath, params: params)
            
            dataProvider.requestData({ (response) -> Void in
                success()
                }, failure: { (errorr) -> Void in
                    failure(error: errorr)
            })
        }
    }
    
    class func deleteEvent(eventId: Int, success:(eventActionResponse : EventActionResponse)->Void, failure:(error : Error) -> Void){
        
        let eventPath = "/event"
        let subPath = "/" + String(eventId)
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .DELETE, path: eventPath + subPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let eventActionResponse = EventActionResponse(json: response)
            success(eventActionResponse: eventActionResponse)
        }, failure: { (error) -> Void in
            failure(error: error)
        })
    }
    
    class func leaveEvent(eventId: Int, success:(eventActionResponse : EventActionResponse)->Void, failure:(error : Error) -> Void){
        
        let eventPath = "/event"
        let subPath = "/leave/" + String(eventId)
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: eventPath + subPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let eventActionResponse = EventActionResponse(json: response)
            success(eventActionResponse: eventActionResponse)
            }, failure: { (error) -> Void in
                failure(error: error)
        })
    }
    
    class func joinEvent(eventId: Int, success:(eventActionResponse : EventActionResponse)->Void, failure:(error : Error) -> Void){
        
        let eventPath = "/event"
        let subPath = "/join/" + String(eventId)
        let params = ["access_token" : KeychainHandler.getUserLoggedToken()!]
        let dataProvider = DataProvider(method: .GET, path: eventPath + subPath, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let eventActionResponse = EventActionResponse(json: response)
            success(eventActionResponse: eventActionResponse)
            }, failure: { (error) -> Void in
                failure(error: error)
        })
    }
    
    class func inviteToEvent(eventID : Int!, userID : Int!, success: (eventActionResponse : EventActionResponse) -> Void, failure:(error : Error) -> Void){
        
        let path = "/event/invite"
        let params : [String : AnyObject] = ["access_token" : KeychainHandler.getUserLoggedToken()!, "userId" : userID, "eventId" : eventID]
        let dataProvider = DataProvider(method: .POST, path: path, params: params)
        
        dataProvider.requestData({ (response) -> Void in
            
            let eventActionResponse = EventActionResponse(json: response)
            success(eventActionResponse: eventActionResponse)
        }, failure: { (error) -> Void in
            failure(error: error)
        })
        
    }
}