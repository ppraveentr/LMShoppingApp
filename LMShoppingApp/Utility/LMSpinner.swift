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
        
        if let window = UIApplication.shared.delegate?.window {
            window?.bringSubview(toFront: self)
        }
    }
}

open class LMSpinner {
    internal static var spinnerView: LMActivityIndicatorView?
    
    open static var style: UIActivityIndicatorViewStyle = .white
    open static var backgroundColor: UIColor = UIColor(white: 0, alpha: 0.6)
    
    internal static var touchHandler: (() -> Void)?
    
    open static func spin(style: UIActivityIndicatorViewStyle = style, backgroundColor: UIColor = backgroundColor, touchHandler: (() -> Void)? = nil) {
        
        spinnerView?.removeFromSuperview()
        
        if spinnerView == nil {
            let frame = UIScreen.main.bounds
            spinnerView = LMActivityIndicatorView(frame: frame)
            spinnerView!.backgroundColor = backgroundColor
            spinnerView!.activityIndicatorViewStyle = style
            spinnerView!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        if let window = UIApplication.shared.delegate?.window {
             window?.addSubview(spinnerView!)
        }
        
        spinnerView!.startAnimating()
        
        if touchHandler != nil {
            self.touchHandler = touchHandler
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(runTouchHandler))
            spinnerView!.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @objc internal static func runTouchHandler() {
        if touchHandler != nil {
            touchHandler!()
        }
    }
    
    open static func stop() {
        if let _ = spinnerView {
            spinnerView!.stopAnimating()
            spinnerView!.removeFromSuperview()
            spinnerView = nil
        }
    }
}
