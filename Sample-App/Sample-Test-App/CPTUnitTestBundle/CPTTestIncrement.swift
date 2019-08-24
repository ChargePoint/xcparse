//
//  CPTTestIncrement.swift
//  CPTUnitTestBundle
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import XCTest
@testable import Sample_Test_App

class CPTTestIncrement: XCTestCase {
    let app = secondViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIncrement() {
        app.buttonPressed(self)
        XCTAssertEqual(app.count, "1")
        for i in 1...5 {
            app.buttonPressed(self)
        }
        XCTAssertEqual(app.count, "6")
    }

}
