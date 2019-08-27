//
//  CPTTestChangeTitle.swift
//  CPTUnitTestBundle
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import XCTest
@testable import xcparse_visualizer
class CPTTestChangeTitle: XCTestCase {

    let app = firstViewController()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testChangeTitle() {
        app.message = "Test1"
        app.isButtonClick(self)
        XCTAssertEqual(app.label, app.message)
        app.message = "Test2"
        app.isButtonClick(self)
        XCTAssertEqual(app.label, app.message)
    }

}
