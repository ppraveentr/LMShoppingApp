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
    
    weak var product: LMProductDetails?

    deinit {
        //Remove observer once deallaocated
        NotificationCenter.default.removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Add observer for Currency Type change
        NotificationCenter.default.addObserver(forName: .LMShoppingViewModel_DidChange_Currency, object: nil, queue: nil) { (notification) in
            
            //Set Product price based on currency change
            if let shoppingModel: LMShoppingViewModel = notification.object as? LMShoppingViewModel,
                let product = self.product {
                //Get current price from Model
                self.priceLabel?.text = shoppingModel.productPrice(for: product)
            }
        }
    }
    
    //Update Cell content based on Product Details
    func configureContent(product: LMProductDetails, price: String) {
        
        //Product title
        self.titleLabel?.text = product.name
        
        //Product price
        self.priceLabel?.text = price
        
        self.product = product
        
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
