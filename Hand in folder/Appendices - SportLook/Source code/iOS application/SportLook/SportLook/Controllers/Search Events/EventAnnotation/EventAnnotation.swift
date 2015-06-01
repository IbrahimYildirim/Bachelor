//
//  EventAnnotation.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 31/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

class EventAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}