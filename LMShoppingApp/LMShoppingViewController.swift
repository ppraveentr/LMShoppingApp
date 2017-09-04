//
//  LMShoppingViewController.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 31/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import UIKit
import Foundation

class LMShoppingViewController: UIViewController {
    
    //ViewModel for shopping List
    @IBOutlet var shoppingViewModel: LMShoppingViewModel!
    
    //Currency Segment control
    @IBOutlet weak var currencySegmentControl: UISegmentedControl!
    
    //Shopping List collectionView
    @IBOutlet weak var shoppingCollectionView: LMShoppingCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show spinner while fetching content from Backend
        LMSpinner.spin(style: .whiteLarge) 
        
        //Fetch Product details from backend
        shoppingViewModel.getProducts {
            //Configure Currency Segment Control based on avaialble conversionType
            self.updateCurrenyList()
            
            //Setup Shopping view
            self.shoppingCollectionView.setUpView()
            
            //Stop spinner when contents finishes laoding
            LMSpinner.stop()
        }
    }
    
    //Update Segment control with valid currency from backend
    func updateCurrenyList() {
        //Set
        self.currencySegmentControl.updateItems(items: self.shoppingViewModel.avaialbleCurrenyConverter())
        
        //set currency based on segement control selection
        self.currencyTypeChanged(currencySegmentControl)
    }
    
    //Segment Controll value-change delegate
    @IBAction func currencyTypeChanged(_ sender: Any) {
        
        //Get title of currenly selected Segment
        if let selectedCur = currencySegmentControl.titleForSegment(at: currencySegmentControl.selectedSegmentIndex) {
            
            //Update current Currency to viewModel
            shoppingViewModel.selectedCurrency = selectedCur
        }
    }
    
    //Relaod Collection view on Device orientation
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        //Relaod collection view cell, when device changes orientaion to resize cell contents
        coordinator.animate(alongsideTransition: nil, completion: { (con) -> Void in
            self.shoppingCollectionView.reloadContent()
        })
    }
}



