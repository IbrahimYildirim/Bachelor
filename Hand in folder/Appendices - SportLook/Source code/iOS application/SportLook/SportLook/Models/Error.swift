//
//  Error.swift
//  SportLook
//
//  Created by Terminator on 17/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class Error {
    
    var code: String
    var message: String
    
    //Figure out what to pass to the constructor
    init(code: String, message: String){
        
        self.code = code
        self.message = message
    }
}
