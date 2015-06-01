//
//  UIArrayExtension.swift
//  SportLook
//
//  Created by Ibrahim Yildirim on 23/03/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

extension Array {
    
    func contains<T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
    
//    func distinct<T : Equatable>(_: T) -> [T] {
//        var rtn = [T]()
//        
//        for x in self {
//            if !rtn.contains(x as T) {
//                rtn += x as T
//            }
//        }
//        
//        return rtn
//    }
//    func contains(object:AnyObject!) -> Bool {
//        if(self.isEmpty) {
//            return false
//        }
//        let array: NSArray = self.bridgeToObjectiveC();
//        
//        return array.containsObject(object)
//    }
//    
//    func indexOf(object:AnyObject!) -> Int? {
//        var index = NSNotFound
//        if(!self.isEmpty) {
//            let array: NSArray = self.bridgeToObjectiveC();
//            index = array.indexOfObject(object)
//        }
//        if(index == NSNotFound) {
//            return Optional.None;
//        }
//        return index
//    }
//    
//    //#pragma mark KVC
//    
//    func getKeyPath(keyPath: String!) -> AnyObject! {
//        return self.bridgeToObjectiveC().valueForKeyPath(keyPath);
//    }
}