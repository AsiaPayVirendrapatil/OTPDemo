//
//  AcsRenderingTypeTests.swift
//  emvco3ds-ios-frameworkTests
//
//  Created by Van Drongelen, Mike on 04/12/2018.
//  Copyright © 2018 UL. All rights reserved.
//

import XCTest
import ObjectMapper

@testable import emvco3ds_ios_framework

class AcsRenderingTypeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapsData() {
        let jsonDictionary: [String: Any] = ["interface": "test_value_interface", "uiType": "test_value_uiType"]
        let item = Mapper<AcsRenderingType>().map(JSON: jsonDictionary)
        
        XCTAssertNotNil(item)
        XCTAssertEqual(item?.inteface, "test_value_interface")
        XCTAssertEqual(item?.uiType, "test_value_uiType")
    }
    
}
