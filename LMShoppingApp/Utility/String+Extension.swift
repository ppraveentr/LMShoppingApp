//
//  String+Extension.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

/**
 Get the class name as a string from a class
 
 - parameter theObject: An NSObject for whitch the string representation of the class will be returned
 - parameter theObject: An AnyClass for whitch the string representation of the class will be returned
 
 - returns: The string representation of the class (name of the bundle dot name of the class)
 */
public func get_classNameAsString(obj: Any) -> String? {
    
    var classNanme = obj
    
    //if obj is subclass of NSObject
    if let object = obj as? NSObject {
        classNanme = type(of: object)
    }
    
    //Get last component of - ClassName
    //FIXIT: Doesn't work all files with special char
    if let object = classNanme as? AnyClass {
        return NSStringFromClass(object).components(separatedBy: ".").last ?? ""
    }
    
    return nil
}

extension String {
    
    //retruns no of chars
    var length: Int {
        return characters.count
    }
    
    /**
     Get UIColor from the string
     - returns: UIColor, if its a valid hex string, else default value of UIColor.gray
     */
    public func hexColor() -> UIColor {
        
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

