//
//  LMProduct.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 01/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import Foundation

class LMCurrency {
    
    var baseType: String
    var toType: String
    var rate: Double
    
    init(base: String, to: String, rate: Double) {
        self.baseType = base
        self.toType = to
        self.rate = rate
    }
    
    class func createCurrency(_ currencyData: NSDictionary) -> LMCurrency? {
        
        //Get Currency's base
        guard let base = currencyData.value(forKeyPath: "from") as? String, base.length > 0 else { return nil }
        
        //Get Currency's toType
        guard let toType = currencyData.value(forKeyPath: "to") as? String, toType.length > 0 else { return nil }
        
        //Get Currency's rate
        guard
            let rate = currencyData.value(forKeyPath: "rate") as? String,
            rate.length > 0,
            let excangeRate = Double(rate)
            else { return nil }
        
        return LMCurrency(base: base, to: toType, rate: excangeRate)
    }
}

class LMProductDetails {
    
    var name: String
    var price: Double
    var currency: String
    var imageURL: String?

    init(name: String, price: Double, currency: String, image: String? = nil) {
        self.name = name
        self.price = price
        self.currency = currency
        self.imageURL = image
    }
    
    class func createProductDetails(_ productData: NSDictionary) -> LMProductDetails? {
        
        //Get Product's name
        guard let name = productData.value(forKeyPath: "name") as? String, name.length > 0 else { return nil }
        
        //Get Product's price
        guard
            let price = productData.value(forKeyPath: "price") as? String, price.length > 0,
            let excangeValue = Double(price)
            else { return nil }
        
        //Get Product's currency
        guard let currency = productData.value(forKeyPath: "currency") as? String, currency.length > 0 else { return nil }

        //Get Product's imageURL
        guard let url = productData.value(forKeyPath: "url") as? String else { return nil }

        return LMProductDetails(name: name, price: excangeValue, currency: currency, image: url)
    }
}

class LMProducts {
    
    var title: String?
    
    var currencyConversion: [LMCurrency]?
    
    var productList: [LMProductDetails] = []
    
    required init(productData: NSDictionary) {
        self.updateWithData(productData: productData)
    }
    
    func updateWithData(productData: NSDictionary) {
        
        //Get Product's title
        if let title = productData.value(forKeyPath: "title") as? String {
            self.title = title
        }
        
        //Get Product's currency conversion
        if let conversionList = productData.value(forKeyPath: "conversion") as? [NSDictionary] {
            
            var conversions: [LMCurrency] = []
            
            conversionList.forEach({ (conversion) in
                if let converted = LMCurrency.createCurrency(conversion) {
                    conversions.append(converted)
                }
            })
            
            self.currencyConversion = conversions
        }
        
        //Get Product
        if let conversionList = productData.value(forKeyPath: "products") as? [NSDictionary] {
            
            var products: [LMProductDetails] = []
            
            conversionList.forEach({ (product) in
                if let converted = LMProductDetails.createProductDetails(product) {
                    products.append(converted)
                }
            })
            
            self.productList = products
        }
    }
    
}
