//
//  LMUtilityTests.swift
//  LMShoppingApp
//
//  Created by Praveen Prabhakar on 02/09/17.
//  Copyright © 2017 Praveen Prabhakar. All rights reserved.
//

import XCTest
@testable import LMShoppingApp

class SwiftTestClass { }

class LMUtilityTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNSObjectClassName() {
        XCTAssertEqual(get_classNameAsString(obj: self), "LMUtilityTests")
    }
    
    func testSwiftClassName() {
        XCTAssertEqual(get_classNameAsString(obj: SwiftTestClass.self), "SwiftTestClass")
    }
    
    func testInvalidClassName() {
        XCTAssertNil(get_classNameAsString(obj: NSClassFromString("dsdasd_sdasd")))
    }
    
    func testHashColor() {
        XCTAssertEqual("#FFFFFF".hexColor(), UIColor(red: 1, green: 1, blue: 1, alpha: 1))
    }
    
    func testInvalidHashColor() {
        XCTAssertEqual("#FFFFF".hexColor(), UIColor.gray)
    }
    
}
