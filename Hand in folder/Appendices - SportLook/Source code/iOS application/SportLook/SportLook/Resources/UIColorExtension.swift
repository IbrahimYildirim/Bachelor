//
//  Colors.swift
//  SportLook
//
//  Created by Terminator on 28/02/15.
//  Copyright (c) 2015 BachelorProject. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexCode:Int) {
        self.init(red:(hexCode >> 16) & 0xff, green:(hexCode >> 8) & 0xff, blue:hexCode & 0xff)
    }
    
    // MARK: - Color swatch
    
    class var COLOR_BLACK_DARK: UIColor {
        return UIColor(hexCode:0x24262D)
    }
    
    class var COLOR_BLACK: UIColor {
        return UIColor(hexCode:0x000000)
    }
    
    class var COLOR_WHITE: UIColor {
        return UIColor(hexCode:0xFFFFFF)
    }
    
    class var COLOR_BLUE_LIGHT: UIColor {
        return UIColor(hexCode:0xC0D6DF)
    }
    
    class var COLOR_BLUE_DARK: UIColor {
        return UIColor(hexCode:0x4F6D7A)
    }
    
    class var COLOR_BLUE_LIGHTER: UIColor {
        return UIColor(hexCode:0xDBE9EE)
    }
    
    class var COLOR_BLUE_FACEBOOK: UIColor {
        return UIColor(hexCode:0x3B5998)
    }
    
    class var COLOR_BLACK_DARK_V2: UIColor {
        return UIColor(hexCode: 0x323336)
    }
    
    class var COLOR_BLUE: UIColor {
        return UIColor(hexCode: 0x4A6FA5)
    }
    
    class var COLOR_BLUE_DARKER: UIColor {
        return UIColor(hexCode: 0x166088)
    }
    
    // MARK: - Specified colors
    
    class var COLOR_NAVBAR_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHT
    }
    
    class var COLOR_NAVBAR_TITLE: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_NAVBAR_BACK_BUTTON: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_VIEW_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHTER
    }
    
    class var COLOR_TEXT_FIELD_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHT
    }
    
    class var COLOR_TEXT_FIELD_TEXT: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_LOGIN_OR: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_BUTTON_TEXT: UIColor {
        return UIColor.COLOR_WHITE
    }
    
    class var COLOR_BUTTON_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_BUTTON_BACKGROUND_FACEBOOK: UIColor {
        return UIColor.COLOR_BLUE_FACEBOOK
    }
    
    class var COLOR_BUTTON_BACKGROUND_LOGIN: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_BUTTON_BACKGROUND_SIGNUP: UIColor {
        return UIColor.COLOR_BLUE_LIGHT
    }
    
    class var COLOR_PROFILE_PHOTO_BORDER: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_EVENT_PICTURE_BACKGROUND: UIColor {
        return UIColor.COLOR_BLACK_DARK_V2
    }
    
    class var COLOR_EVENT_INFO_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHTER
    }
    
    class var COLOR_EVENT_INFO_LABEL_SECONDARY: UIColor {
        return UIColor.COLOR_BLUE
    }
    
    class var COLOR_EVENT_INFO_LABEL_PRIMARY: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_EVENT_INFO_SEPARATOR: UIColor {
        return UIColor.COLOR_BLUE_DARKER
    }
    
    class var COLOR_EVENT_INFO_BOTTOM_LABEL: UIColor {
        return UIColor.COLOR_BLUE_DARKER
    }
    
    class var COLOR_FAVORITE_SPORTS_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHTER
    }
    
    class var COLOR_EMPTY_PLACEHOLDER_LABEL: UIColor {
        return UIColor.COLOR_BLUE_DARK
    }
    
    class var COLOR_EMPTY_PLACEHOLDER_BACKGROUND: UIColor {
        return UIColor.COLOR_BLUE_LIGHTER
    }
}
