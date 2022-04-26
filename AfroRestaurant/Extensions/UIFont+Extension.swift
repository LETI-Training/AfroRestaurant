//
//  UIFont+Extension.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//

import UIKit


extension UIFont {
    
    enum FontStyle: String {
        case regular = "Roboto-Regular"
        
        case medium = "Roboto-Medium"
        case mediumItalic = "Roboto-MediumItalic"
        
        case bold = "Roboto-Bold"
        case boldItalic = "Roboto-BoldItalic"
        
        case italic = "Roboto-Italic"
        
        case light = "Roboto-Light"
        case lightItalic = "Roboto-LightItalic"
        
        case thin = "Roboto-Thin"
        case thinItalic = "Roboto-ThinItalic"
        
        case extraBold = "Roboto-Black"
        case extraBoldItalic = "Roboto-BlackItalic"
    }
    
    class func font(_ style: FontStyle, size: CGFloat) -> UIFont {
        UIFont(name: style.rawValue, size: size)!
    }
}

