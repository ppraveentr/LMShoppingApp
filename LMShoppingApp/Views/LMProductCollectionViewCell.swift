//
//  LMProductCollectionViewCell.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit

class LMProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var priceLabel: UILabel?
    
    //Update Cell content based on Product Details
    func configureContent(product: LMProductDetails, price: String) {
        
        //Product title
        self.titleLabel?.text = product.name
        
        //Product price
        self.priceLabel?.text = price
        
        //Load Product image from url
        if let url = product.imageURL {
            self.imageView?.downloadedFrom(link: url) {
                //Stop laodingIndicator
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    //Size of each item, based on baseView
    func getSize(baseView: UIView) -> CGSize {
        
        //Get item size fitting max for baseView size
        let size = self.systemLayoutSizeFitting(
            CGSize(width: baseView.frame.width, height: baseView.frame.height),
            withHorizontalFittingPriority: UILayoutPriorityRequired,
            verticalFittingPriority: UILayoutPriorityRequired)
        
        return size
    }
}
