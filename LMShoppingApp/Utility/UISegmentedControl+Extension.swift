//
//  UISegmentedControl+Extension.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    
    /**
     Updates segemnts-items based on the content provided
     
     - parameter newItems: A list of string, thats set as title for the SegmentControl
     */
    func updateItems(items newItems: [String]) {

        //Remove any previous segments
        self.removeAllSegments()
        
        //Inset new segment-Title
        newItems.enumerated().forEach { (i, item) in
            self.insertSegment(withTitle: item, at: i, animated: false)
        }
        
        //Update segment Appearance
        self.customizeAppearanceForCurrency()
        
        self.selectedSegmentIndex = 0
    }
    
    func customizeAppearanceForCurrency(for height: Int = 1) {
        
        //title-font for normal state
        setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.black], for:.normal)
        
        //title-font for selected state
        setTitleTextAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white], for:.selected)
        
        //divider-image between segment with spacing for '10px'
        setDividerImage(UIImage().colored(with: .clear, size: CGSize(width: 10, height: height)), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        //text-color for normal segment
        setBackgroundImage(UIImage().colored(with: "#E7E6E6".hexColor(), size: CGSize(width: 1, height: height)), for: .normal, barMetrics: .default)
        
        //text-color for selected segment
        setBackgroundImage(UIImage().colored(with: "#5D9AD5".hexColor(), size: CGSize(width: 1, height: height)), for: .selected, barMetrics: .default);
        
        //Add border for each segment
        for  borderview in subviews {
            borderview.layer.borderWidth = 1.3
            borderview.layer.backgroundColor = UIColor.black.cgColor
            borderview.layer.cornerRadius = 5.0
            borderview.clipsToBounds = true
        }
    }
}

extension UIImage {
    
    //Generate image from color
    func colored(with color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
