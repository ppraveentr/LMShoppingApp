//
//  UIView+Extension.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

public extension UIView {
    
    public class func getNIBFile() -> UINib? {
        //Get nib based on once's class name
        return UINib(nibName: get_classNameAsString(obj: self) ?? "", bundle: nil)
    }
    
    public class func fromNib(_ owner: Any? = nil) -> UIView? {
        //Get view based on once's class name
        return fromNib(named: get_classNameAsString(obj: self) ?? "", owner: owner)
    }

    //Retruns first view from the nib file
    public class func fromNib(named name: String, owner: Any? = nil) -> UIView? {
        //Get all object inside the nib
        let allObjects = Bundle.main.loadNibNamed(name, owner: owner, options: nil) ?? []
        //Get first view object
        if let nib = allObjects.first as? UIView {
            return nib
        }
        
        return nil
    }
    
    //Add once's xib-view as subView
    @objc public func xibSetup(className: UIView.Type) {
        var contentView : UIView?

        //Get view from nib
        contentView = className.fromNib(self)
        //Set contents tag as self'hash, just for unique identifiation
        contentView?.tag = self.hash
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
    }
}
