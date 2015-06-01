//
//  UploadImageProvider.swift
//  SportLook
//
//  Created by Terminator on 02/04/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import Foundation

class UploadImageProvider {
    
    let uploadProfilePicturePath = "/user/uploadImage"
    let uploadEventPicturePath = "/event/uploadImage"
    
    func uploadProfilePicture(image: UIImage, success: (response: UploadProfilePictureResponse) -> Void, failure: (error: Error) -> Void){
        
        //Compress image
        let img = Utils.fixOrientation(image)
        
        var compression : CGFloat = 0.9
        let maxCompression : CGFloat = 0.1
        let maxFileSize = 400*1024
        
        var imageData = UIImageJPEGRepresentation(img, compression)
        
        while (imageData.length > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(img, compression)
        }
        
        let params = ["avatar": NetData(jpegImage: img, compressionQuanlity: compression, filename: "profilePicture.jpeg")]
        let completePath = uploadProfilePicturePath + "?access_token=" + KeychainHandler.getUserLoggedToken()!
        let dataProvider = DataProvider(method: .POST, path: completePath, params: params)
        
        dataProvider.uploadPicture(img, success: { (response) -> Void in
            
            let uploadProfilePictureResponse = UploadProfilePictureResponse(dictionary: response)
            success(response: uploadProfilePictureResponse)
            
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    func uploadEventPicture(image: UIImage, eventId: String, success: (response: UploadEventPictureResponse) -> Void, failure: (error: Error) -> Void){
        
        //Compress the image
        let img = Utils.fixOrientation(image)
        
        var compression : CGFloat = 0.9
        let maxCompression : CGFloat = 0.1
        let maxFileSize = 400*1024
        
        var imageData = UIImageJPEGRepresentation(img, compression)
        
        while (imageData.length > maxFileSize && compression > maxCompression)
        {
            compression -= 0.1;
            imageData = UIImageJPEGRepresentation(img, compression)
        }
        
        //Send it
        let params = ["image": NetData(jpegImage: img, compressionQuanlity: compression, filename: "eventPicture.jpeg")]
        let completePath = uploadEventPicturePath + "?access_token=" + KeychainHandler.getUserLoggedToken()! + "&eventId=" + eventId
        let dataProvider = DataProvider(method: .POST, path: completePath, params: params)
        
        dataProvider.uploadPicture(img, success: { (response) -> Void in
            
            let uploadEventPictureResponse = UploadEventPictureResponse(dictionary: response)
            success(response: uploadEventPictureResponse)
            
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    
    
}