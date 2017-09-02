//
//  LMSpinner.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 02/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation
import UIKit

class LMActivityIndicatorView: UIActivityIndicatorView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Always bring to front of view
        if let window = UIApplication.shared.delegate?.window {
            window?.bringSubview(toFront: self)
        }
    }
}

open class LMSpinner {
    //Static single Spinner
    internal static var spinnerView: LMActivityIndicatorView?
    
    //White color spinner
    open static var style: UIActivityIndicatorViewStyle = .white
    
    //Black color bg, with .6 alpha
    open static var backgroundColor: UIColor = UIColor(white: 0, alpha: 0.6)
    
    //Handler when spinner is loading
    internal static var touchHandler: (() -> Void)?
    
    open static func spin(style: UIActivityIndicatorViewStyle = style, backgroundColor: UIColor = backgroundColor, touchHandler: (() -> Void)? = nil) {
        
        //Remove exising spinner
        spinnerView?.removeFromSuperview()
        
        //Creare new spinner if nil
        if spinnerView == nil {
            
            //Size of the main screen
            let frame = UIScreen.main.bounds
            spinnerView = LMActivityIndicatorView(frame: frame)
            
            spinnerView!.backgroundColor = backgroundColor
            spinnerView!.activityIndicatorViewStyle = style
            
            //To expand to entier window
            spinnerView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        //Add spinner to mainWindow
        if let window = UIApplication.shared.delegate?.window {
             window?.addSubview(spinnerView!)
        }
        
        //Start Animating
        spinnerView!.startAnimating()
        
        //Setup gesture, if user sends any touch-handler
        if touchHandler != nil {
            self.touchHandler = touchHandler
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(runTouchHandler))
            spinnerView!.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    //Invoke touch-handler
    @objc internal static func runTouchHandler() {
        if touchHandler != nil {
            touchHandler!()
        }
    }
    
    //Stop spinner
    open static func stop() {
        
        //if available, stop and remove from superView, make it nill
        if let _ = spinnerView {
            spinnerView!.stopAnimating()
            spinnerView!.removeFromSuperview()
            spinnerView = nil
        }
    }
}
