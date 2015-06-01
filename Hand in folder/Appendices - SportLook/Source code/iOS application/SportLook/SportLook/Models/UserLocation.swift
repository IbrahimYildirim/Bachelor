//
//  UserLocation.swift
//  SportLook
//
//  Created by Terminator on 27/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class UserLocation {
    
    var latitude : Double
    var longitude : Double
    var city: String
    var country: String
    var formattedAddress: String
    
    init(latitude: Double, longitude: Double, city: String, country: String, formattedAddress: String){
        
        self.latitude = latitude
        self.longitude = longitude
        self.city = city
        self.country = country
        self.formattedAddress = formattedAddress
    }
}