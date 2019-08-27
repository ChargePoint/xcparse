//
//  CPTNavigateTabs.swift
//  CPTBundleWithMultipleSuites
//
//  Created by Rishab Sukumar on 8/13/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import XCTest

class CPTNavigateTabs: XCTestCase {

    let app = XCUIApplication()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        let testsTab = self.app.radioButtons["Tests"]
        testsTab.click()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.app.terminate()
    }

    func testMessageTab() {
        let testButton : XCUIElement = self.app.buttons["testButton"]
        testButton.click()
        let messageTab = self.app.radioButtons["Message"]
        messageTab.click()
        saveScreenshot(name: "CPTAutomationMessageTab")
    }
    
    func testMessageCountTab() {
        let testButton : XCUIElement = self.app.buttons["testButton"]
        testButton.click()
        let messageCountTab = self.app.radioButtons["Message Counts"]
        messageCountTab.click()
        saveScreenshot(name: "CPTAutomationMessageCountTab")
    }
    
    func testRandomTab() {
        let testButton : XCUIElement = self.app.buttons["testButton"]
        testButton.click()
        let randomTab = self.app.radioButtons["Random"]
        randomTab.click()
        saveScreenshot(name: "CPTAutomationRandomTab")
    }
    
    func saveScreenshot(name : String) {
        let screenshot = self.app.screenshot()
        let attachment : XCTAttachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        attachment.name = name
        add(attachment)
    }
    
}
