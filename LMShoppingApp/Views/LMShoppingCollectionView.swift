//
//  LMShoppingCollectionView.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 02/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit
import Foundation

//@IBDesignable
class LMShoppingCollectionView: UIView {

    //viewModel
    @IBOutlet weak var shoppingViewModel: LMShoppingViewModel!
    
    //Product Title
    @IBOutlet weak var titleLabel: UILabel!
    
    //Collection View
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Pagination Control
    @IBOutlet weak var pageControl: UIPageControl!
 
    //Sample cell to calcualte size for each item
    lazy var sampleCell = LMProductCollectionViewCell.fromNib() as? LMProductCollectionViewCell

    //Load's nib file to View
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup(className: LMShoppingCollectionView.self)
    }
    
    //Load's nib file to View
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup(className: LMShoppingCollectionView.self)
    }
    
    //Setup view content
    override func xibSetup(className: UIView.Type) {
        //Load's nib file to View, by invoking super
        super.xibSetup(className: className)
        
        //TODO: xcode crashing
        //addObserver(self, forKeyPath: "shoppingViewModel.selectedCurrency", options: [.old, .new], context: nil)
        
        //Collection View cell registeration
        self.collectionView?.register(LMProductCollectionViewCell.getNIBFile(),
                                      forCellWithReuseIdentifier: "kProductCellIdentifier")
    }
    
    //Setup View after API service call
    func setUpView() {
        
        //Set page title
        self.titleLabel.text = self.shoppingViewModel.productTitle()
        
        //Reload Collection cell
        self.collectionView.reloadData()
    }
    
    //Reload only visible content in collectionView
    func reloadContent() {
        let visbi = self.collectionView.indexPathsForVisibleItems
        
        if visbi.count > 0 {
            self.collectionView.reloadItems(at: visbi)
        }else{
            self.collectionView.reloadData()
        }
        
        //Run on the main queue as completion handler handles UI display and we don't want to block any UI code.
        DispatchQueue.main.async {
            //Calculate no of pages in collection view
           self.pageControl.numberOfPages = Int(self.collectionView.contentSize.width / self.frame.width)
        }
    }
    
//    // MARK: - Key-Value Observing
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
//                               context: UnsafeMutableRawPointer?) {
//        
//        if keyPath == "shoppingViewModel.selectedCurrency" {
//            self.reloadContent()
//        }else{
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
//    }
}

//MARK: CollectionView Delegates
extension LMShoppingCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //No of Items in each section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return shoppingViewModel.numberOfProductsToDisplay(in: section)
    }
    
    //Collection item Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kProductCellIdentifier", for: indexPath)
        
        if
            let cell = cell as? LMProductCollectionViewCell,
            let prod = shoppingViewModel.productToDisplay(for: indexPath) {
            
            //Get dispaly price for the product
            let val = shoppingViewModel.productPrice(for: prod)
            cell.configureContent(product: prod, price: val)
        }
        
        return cell
    }
    
    //Collection Item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let prod = shoppingViewModel.productToDisplay(for: indexPath) {
            sampleCell?.configureContent(product: prod,price: "")
        }
        //Get item size based on content sizing
        return sampleCell?.getSize(baseView: collectionView) ?? CGSize(width: 215, height: 307)
    }
}

//MARK: Pagination
extension LMShoppingCollectionView {
    
    //Scroll collection view to selected page
    @IBAction func pageControlValueChanged() {
     
        let page = pageControl.currentPage
        
        if page < 0 || (page >= pageControl.numberOfPages) { return }
        
        var frame = self.collectionView.frame;
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        
        self.collectionView.scrollRectToVisible(frame, animated: true)
    }
    
    //ScrollView delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = currentPage
    }
    
}
