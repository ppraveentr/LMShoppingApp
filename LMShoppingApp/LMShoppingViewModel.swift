//
//  LMShoppingViewModel.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

class LMShoppingViewModel: NSObject {
 
    //Define an products property that will hold the data from the backend
    //This is marked an optional (?) because we might not get back data
    var products: LMProducts?
    
    //User selected Currency
    dynamic var selectedCurrency: String = ""
    
    //Custom Symbol for Currency, can get from backend
    fileprivate let customCurrencySign: [String:String] = ["INR":"₹"]
    
    //values to display in collection
    func avaialbleCurrenyConverter() -> [String] {
        return ["INR", "AED", "SAR"]
        
//        var currencyList: Set<String> = []
//        
//        //Get unqie set of Currency value
//        products?.currencyConversion?.forEach({ (currency) in
//            currencyList.insert(currency.baseType)
//        })
//        
//        return currencyList.flatMap({ return $0 })
    }
    
    //Title of the product list
    func productTitle() -> String? {
        return products?.title
    }
    
    //no of products to display in the section
    func numberOfProductsToDisplay(in section: Int) -> Int {
        return products?.productList.count ?? 0
    }
    
    //values to display in collection
    func productToDisplay(for indexPath: IndexPath) -> LMProductDetails? {
        return products?.productList[indexPath.row]
    }
    
    //Calculates the Product price based on Selected-Currency
    func productPrice(for product: LMProductDetails) -> String {
        return self.productPrice(for: product, convCurrency: selectedCurrency)
    }
    
    //Calculates the Product price based on passed-on-Currency
    func productPrice(for product: LMProductDetails, convCurrency: String?) -> String {
        
        guard let convCurrency = convCurrency, convCurrency.length > 0 else { return "" }
        
        //If required Currecy is same as base type
        if product.currency == convCurrency {
            return self.getDisplayString(for: product.price, currencyType: convCurrency)
        }
        //Find direct convertion value,
        else if let directConversion = products?.currencyConversion?.filter({ ($0.baseType == convCurrency && $0.toType == product.currency) || ($0.toType == convCurrency && $0.baseType == product.currency) }).first {
         
            //Incase if Direct conversion avaialble
            var price = (product.price * directConversion.rate)
            
            //If product-currency is of toType
            if (directConversion.baseType == convCurrency && directConversion.toType == product.currency) {
                price = (product.price / directConversion.rate)
            }
            
            //print(product.currency," ", product.price, " :: >> ", convCurrency, "@", directConversion.rate, " :=: " , price)

            return self.getDisplayString(for: price, currencyType: convCurrency)
        }
        
        //If needed : Find inDirect Conversion
        
        return ""
    }
    
    //Returns the Display priceValue for the Product
    func getDisplayString(for price: Double, currencyType: String) -> String {
        
        //Check if any custome symbol avaialble for Currecy
        let currencyType = customCurrencySign[currencyType] ?? currencyType
        
        //Get formated value: '<Currecy-Symbol> <2-decimal-digit price>'
        return String.localizedStringWithFormat("%@ %.2f", currencyType, price)
    }
}

extension LMShoppingViewModel {
    
    //Directly accesses the fetchProductList to make the API call
    func getProducts(completion: @escaping () -> Void) {
        
        //call on the fetchProductList to fetch the Product list
        LMNetworkManager.fetchProductList { (productDictionary, error) in
            
            //Run on the main queue as completion handler handles UI display and we don't want to block any UI code.
            DispatchQueue.main.async {
                
                //assign to local products array to our returned json
                if let productData = productDictionary {
                    self.products = LMProducts(productData: productData)
                }
                
                //call completion that we will reload data in our view controller tableview
                completion()
            }
        }
    }
}
