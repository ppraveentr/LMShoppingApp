//
//  LMViewLoadingTests.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 02/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import LMShoppingApp

class LMViewLoadingTests: XCTestCase {
    
    fileprivate static var productJSON: [String : Any] = [
        "conversion": [
            //Valid sets
            [ "from":"AED", "to":"SAR", "rate":"0.8" ],
            [ "from":"AED", "to":"INR", "rate":"17.1" ],
            [ "from":"SAR", "to":"INR", "rate":"17.2" ],
            [ "from":"INR", "to":"AED", "rate":"0.057" ]
        ],
        "title":"Printed Kurta upto 30% off",
        "products":
            [
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
                ]
        ]
    ]
    
    var product: LMProducts = LMProducts(productData: productJSON as NSDictionary)
    
    var controllerUnderTest: LMShoppingViewController!
    
    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "Main",
                                           bundle: nil).instantiateInitialViewController() as! LMShoppingViewController
        
        controllerUnderTest.shoppingViewModel.products = product
    }
    
    let shoppingView: LMShoppingCollectionView = { () -> LMShoppingCollectionView in
        
        let view = LMShoppingCollectionView.init(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 320)))
        
        return view
    }()
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testInitalViewController() {
        XCTAssertNotNil(controllerUnderTest)
    }
    
    func testShoppingCollectionView() {
        
        let shoppingView = self.shoppingView

        XCTAssertNotNil(shoppingView)
        
        //Test if xib is loaded properly
        XCTAssertNotNil(shoppingView.viewWithTag(shoppingView.hash))
    }
    
    func testProductCollectionView() {
        
        let sampleCell = LMProductCollectionViewCell.fromNib() as? LMProductCollectionViewCell
        
        XCTAssertNotNil(sampleCell)
    }
    
//    func testShoppingCollectionCellView() {
//        
//        let shoppingView = self.shoppingView
//        
//        XCTAssertNotNil(shoppingView)
//        
//        controllerUnderTest.shoppingCollectionView = shoppingView
//    }
    
    //MARK: Segment Controll Tests
    let segmentControll: UISegmentedControl = { () -> UISegmentedControl in
        
        let segment = UISegmentedControl.init()
        
        segment.updateItems(items: ["hi","bye"])
        
        segment.selectedSegmentIndex = 0
        
        return segment
    }()

    func testSegmentedControl() {
        
        let segment = segmentControll
        
        XCTAssertNotNil(segment)
        
        XCTAssertEqual(segment.numberOfSegments, 2)
        
        XCTAssertEqual(segment.titleForSegment(at: 0), "hi")
        
        XCTAssertEqual(segment.titleForSegment(at: 1), "bye")
    }

    func testSegmentedBorderColor() {
        
        let segment = segmentControll
        
        XCTAssertNotNil(segment)
        
        //Add border for each segment
        for  borderview in segment.subviews {
            
            XCTAssertEqual(borderview.layer.borderWidth, 1.3)
            
            XCTAssertEqual(borderview.layer.backgroundColor, UIColor.black.cgColor)
            
            XCTAssertEqual(borderview.layer.cornerRadius, 5.0)
        }
    }
    
    func testSegmentedItemColor() {
        
        let segment = segmentControll
        
        XCTAssertNotNil(segment)
        
        //Test for selected-segment test color
        if let selectedAtt = segment.titleTextAttributes(for: .selected),
            let selectedColor = selectedAtt[NSAttributedStringKey.foregroundColor] as? UIColor {
            
            XCTAssertEqual(selectedColor, UIColor.white)
        }else{
            XCTFail("Error: .selected Segmented Item FG color mismatch")
        }

        //Test for normal-segment test color
        if let selectedAtt = segment.titleTextAttributes(for: .normal),
            let selectedColor = selectedAtt[NSAttributedStringKey.foregroundColor] as? UIColor {
            
            XCTAssertEqual(selectedColor, UIColor.black)
        }else{
            XCTFail("Error: .normal Segmented Item FG color mismatch")
        }
    }
}
