//
//  LMShoppingAppTests.swift
//  LMShoppingAppTests
//
//  Created by Praveen Prabhakar on 31/08/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import LMShoppingApp

class LMShoppingAppTests: XCTestCase {
    
    fileprivate static var productJSON: [String : Any] = [
        "conversion": [
            //Valid sets
            [ "from":"AED", "to":"SAR", "rate":"0.8" ],
            [ "from":"AED", "to":"INR", "rate":"17.1" ],
            [ "from":"SAR", "to":"INR", "rate":"17.2" ],
            [ "from":"INR", "to":"AED", "rate":"0.057" ],
            //Invalid sets below
            [ "from":"", "to":"AED", "rate":"0.057" ],
            [ "from":"INR", "to":"", "rate":"0.057" ],
            [ "from":"INR", "to":"AED", "rate":"" ]
        ],
        "title":"Printed Kurta upto 30% off",
        "products":
            [
                //Valid sets
                [
                    "url":"http://be962883fa4932cb8c45-4918b6c23895973d0d77439479dabaa9.r81.cf3.rackcdn.com/119580217-PA008_01-800.jpg",
                    "name":"Avent Medium-flow Silicone Teats",
                    "price":"27.00",
                    "currency": "AED"
                ],
                [
                    "url":"http://be962883fa4932cb8c45-4918b6c23895973d0d77439479dabaa9.r81.cf3.rackcdn.com/117514970-MOD9611_01-800.jpg",
                    "name":"Juniors Cream Bed Guard",
                    "price":"80.00",
                    "currency": "SAR"
                ],
                [
                    "url":"http://7363c8e5d644af3f61fe-f801ca07733addcf236da446f6ef5b12.r6.cf3.rackcdn.com/BA68420_01-215.jpg",
                    "name":"Giggles Glider Chair and Ottoman",
                    "price":"995.00",
                    "currency": "INR"
                ],
                //Invalid sets below
                [
                    "url":"http://7363c8e5d644af3f61fe-f801ca07733addcf236da446f6ef5b12.r6.cf3.rackcdn.com/BA68420_01-215.jpg",
                    "name":"",
                    "price":"995.00",
                    "currency": "INR"
                ],
                [
                    "url":"http://be962883fa4932cb8c45-4918b6c23895973d0d77439479dabaa9.r81.cf3.rackcdn.com/119580217-PA008_01-800.jpg",
                    "name":"Avent Medium-flow Silicone Teats",
                    "price":"",
                    "currency": "AED"
                ],
                [
                    "url":"http://be962883fa4932cb8c45-4918b6c23895973d0d77439479dabaa9.r81.cf3.rackcdn.com/119580217-PA008_01-800.jpg",
                    "name":"Avent Medium-flow Silicone Teats",
                    "price":"995.00",
                    "currency": ""
                ]
        ]
    ]

    fileprivate static let singleCurency: NSDictionary = [ "from":"AED", "to":"SAR", "rate":"0.8" ]

    lazy var productDetails = LMProductDetails.createProductDetails([
        "url":"http://be962883fa4932cb8c45-4918b6c23895973d0d77439479dabaa9.r81.cf3.rackcdn.com/119580217-PA008_01-800.jpg",
        "name":"Avent Medium-flow Silicone Teats",
        "price":"27.00",
        "currency": "AED"
        ])
    
    var product: LMProducts?
    
    let viewModel = LMShoppingViewModel()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        product = LMProducts(productData: LMShoppingAppTests.productJSON as NSDictionary)
        
        viewModel.products = product
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: Products Test
    func testProductCreation() {
        
        XCTAssertNotNil(product)

        XCTAssertEqual(product?.productList.count, 3)
    }
    
    func testProdcutTitle() {
        XCTAssertEqual(product?.title, "Printed Kurta upto 30% off")
    }
    
    func testProdcutsCurrencyCreation() {
        XCTAssertEqual(product?.currencyConversion?.count, 4)
    }
    
    //MARK: Products Details Test
    func testProductDetailsCreation() {
        
        XCTAssertNotNil(productDetails!)
        
        XCTAssertEqual(productDetails?.name, "Avent Medium-flow Silicone Teats")
        
        XCTAssertEqual(productDetails?.price, 27.00)

        XCTAssertEqual(productDetails?.currency, "AED")
    }
    
    //MARK: Currency Creation Test
    func testCurrencyCreation() {
        
        let currency = LMCurrency.createCurrency(LMShoppingAppTests.singleCurency)

        XCTAssertNotNil(currency)

        XCTAssertEqual(currency?.baseType, "AED")
        
        XCTAssertEqual(currency?.toType, "SAR")
        
        XCTAssertEqual(currency?.rate, 0.8)
    }
    
    //MARK: LMShoppingViewModel
    func testShoppingViewModelCreation() {
        
        XCTAssertEqual(viewModel.productTitle(), "Printed Kurta upto 30% off")
        
        XCTAssertEqual(viewModel.numberOfProductsToDisplay(in: 0), 3)
        
        viewModel.selectedCurrency = "AED"
        
        XCTAssertEqual(viewModel.selectedCurrency, "AED")

        XCTAssertEqual(viewModel.productPrice(for: productDetails!), "AED 27.00")
    }
    
     func testCurrencyConversion() {
        
        XCTAssertEqual(viewModel.productPrice(for: productDetails!, convCurrency: "AED"), "AED 27.00")
        
        XCTAssertEqual(viewModel.productPrice(for: productDetails!, convCurrency: "SAR"), "SAR 21.60")
    }
    
    func testInvalidCurrencyConversion() {
        
        viewModel.selectedCurrency = "ERE"
        
        XCTAssertEqual(viewModel.productPrice(for: productDetails!), "")
        
        XCTAssertEqual(viewModel.productPrice(for: productDetails!, convCurrency: "INERE"), "")
    }
    
    func testCurrencyDisplayConversion() {
        
        XCTAssertEqual(viewModel.getDisplayString(for: 21.60, currencyType: "SAR"), "SAR 21.60")
        
        XCTAssertEqual(viewModel.getDisplayString(for: 21.60, currencyType: "AED"), "AED 21.60")
        
        XCTAssertEqual(viewModel.getDisplayString(for: 21.60, currencyType: "INR"), "₹ 21.60")
    }
    
    func testPerformanceExample() {
        self.measure {
            _ = LMProducts(productData: LMShoppingAppTests.productJSON as NSDictionary)
        }
    }
    
    // Asynchronous test: success fast, failure slow
    func testNetworkManager() {
        
        let promise = expectation(description: "Status code: 200")
        
        LMNetworkManager.fetchProductList { (dicVal, error) in
            //If error
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }
                //if there is not error
            else if dicVal != nil {
                promise.fulfill()
            }
        }
        //Timeout: '5'
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
