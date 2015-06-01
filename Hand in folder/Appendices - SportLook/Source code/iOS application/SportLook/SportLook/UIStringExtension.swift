//
//  UIStringExtension.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 19/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

extension String {
    var capitalizeIt:String {
        var result = Array(self)
        if !isEmpty { result[0] = Character(String(result.first!).uppercaseString) }
        return String(result)
    }
    var capitalizeFirst:String {
        var result = self
        result.replaceRange(startIndex...startIndex, with: String(self[startIndex]).capitalizedString)
        return result
    }
    
}