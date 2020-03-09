//
//  AppDelegateTest.swift
//  emvco3ds-ios-appTests
//
//  Created by Van Drongelen, Mike on 04/12/2018.
//  Copyright © 2018 UL Transaction Security. All rights reserved.
//

import XCTest
import emvco3ds_ios_framework

@testable import emvco3ds_ios_app

class AppDelegateTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateFramework() {
        Emvco3dsFramework.setup(appName: "Test app", factory: Factory())
        
        XCTAssertNotNil(Emvco3dsFramework.factory)
        XCTAssertNotNil(Emvco3dsFramework.navigationController)
        
        XCTAssertEqual(Emvco3dsFramework.navigationController?.navigationBar.topItem?.title, "Test app")
        
    }
}
