//
//  UserLocationHandler.swift
//  SportLook
//
//  Created by Terminator on 25/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class UserLocationHandler {
    
    class func getUserLocation (success: (response: UserLocation) -> Void, failure: (error: Error) -> Void) {
        
        let locationManager = LocationManager.sharedInstance
        
        if(shouldFetchUserLocation()){
            
            locationManager.autoUpdate = true
            locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
                
                if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined){
                    if(error != nil){
                        //this error means that there is no network connectivity
                        println("User location failed: " + error!)
                        let errorResulted = Error(code: "To be set...", message: "Retrieving user location failed. Try again!")
                        failure(error: errorResulted)
                    } else {
//                        println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
                        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
                            
                            if (error != nil){
                                let errorResulted = Error(code: "To be set...", message: "Retrieving user location failed. Try again!")
                                failure(error: errorResulted)
                            } else {
                                
                                let city = reverseGeocodeInfo?.valueForKey("locality") as! String
                                let country = reverseGeocodeInfo?.valueForKey("country") as! String
                                let formattedAddress = reverseGeocodeInfo?.valueForKey("formattedAddress") as! String
                                let userLocation = UserLocation(latitude: latitude, longitude: longitude, city: city, country: country, formattedAddress: formattedAddress)
                                
                                success(response: userLocation)
                            }
                        }
                        locationManager.stopUpdatingLocation()
                    }
                } else {
                    //let iOS display its 'AlertView' asking for authorization
                }
            }
        }
    }
    
    private class func shouldFetchUserLocation() -> Bool {
        
        var shouldFetchLocation = false
        if(CLLocationManager.locationServicesEnabled()) {
            
            switch(CLLocationManager.authorizationStatus()){
                
            case CLAuthorizationStatus.AuthorizedAlways:
                shouldFetchLocation = true
            case CLAuthorizationStatus.AuthorizedWhenInUse:
                shouldFetchLocation = true
            case CLAuthorizationStatus.Denied:
                showNoticeWithMessage("The location services have been denied for SportLook in Settings. Please authorize!")
            case CLAuthorizationStatus.Restricted:
                showNoticeWithMessage("The location services have been restricted for SportLook in Settings. Please authorize!")
            case CLAuthorizationStatus.NotDetermined:
//                showNoticeWithMessage("Authorization to use location services hasn't been granted in Settings. Please authorize!")
                shouldFetchLocation = true
            default:
                break
            }
        } else {
            showNoticeWithMessage("The location services seem to be disabled in Settings. Please enable them!")
            return false
        }
        return shouldFetchLocation
    }
    
    private class func showNoticeWithMessage(message: String) {
        
        let alert = SCLAlertView()
        alert.showNotice("Oups!", subTitle: message, closeButtonTitle: "Ok")
    }
    
    private class func showErrorWithMessage(message: String) {
        
        let alert = SCLAlertView()
        alert.showError("Oups!", subTitle: message, closeButtonTitle: "Ok")
    }
}