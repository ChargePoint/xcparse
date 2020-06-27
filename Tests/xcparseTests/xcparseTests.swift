import XCTest
import class Foundation.Bundle
import xcparse
import XCParseCore

final class xcparseTests: XCTestCase {

    override func tearDown() {
        if FileManager.default.fileExists(atPath: temporaryOutputDirectoryURL.path) {
            try? FileManager.default.removeItem(at: temporaryOutputDirectoryURL)
        }
        super.tearDown()
    }

    func testScreenshots() throws {

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // check for the files
        let fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.path)

        XCTAssertTrue(fileUrls.count ==  6)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 3)
    }

    func testDivideByTestPlanConfig() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--test-plan-config",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // We have three configurations ko, en, de
        //  check for files under ko
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("ko").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under en
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("en").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under de
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("de").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)

    }

    func testDivideByOS() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--os",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // check for the files. The os in xcresult is 13.5 for simulator so we append
        // "13.5" to temporary directory

        let fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("13.5").path)

        XCTAssertTrue(fileUrls.count ==  6)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 3)
    }

    func testDivideByModel() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--model",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // check for the files. The model in xcresult is iPhone 11 for simulator so we append
        // "iPhone 11" to temporary directory

        let fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("iPhone 11").path)

        XCTAssertTrue(fileUrls.count ==  6)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 3)
    }

    func testDivideByLanguage() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--language",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // We have three languages ko, en, de
        //  check for files under ko
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("ko").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under en
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("en").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under de
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("de").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
    }

    func testDivideByRegion() throws {
        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--region",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // We have three regions US, KR, DE
        //  check for files under KR
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("KR").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under US
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("US").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
        // check for files under DE
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("DE").path)
        XCTAssertTrue(fileUrls.count == 2)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 1)
    }

    func testDivideByTest() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["screenshots","--test",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()

        // There are two tests testTodayWidgetScreenshot() and testMainViewScreenshot() under bitrise_screenshot_automationUITests
        //  check for files under KR
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("bitrise_screenshot_automationUITests").appendingPathComponent("testTodayWidgetScreenshot()").path)
        XCTAssertTrue(fileUrls.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 3)
        // check for files under US
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("bitrise_screenshot_automationUITests").appendingPathComponent("testMainViewScreenshot()").path)
        XCTAssertTrue(fileUrls.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 3)

    }

    func testGetCodeCoverage() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["codecov",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.path)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("action.xccovreport")}.count == 1)
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("action.xccovarchive").path)
        XCTAssertTrue(fileUrls.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("Coverage")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("Index")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("Metadata.plist")}.count == 1)

    }

    func testGetLogs() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["logs",file.url.path,temporaryOutputDirectoryURL.path]

        try runAndWaitForXCParseProcess()
        var fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("1_Test").path)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("action.txt")}.count == 1)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("build.txt")}.count == 1)
        fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.appendingPathComponent("1_Test").appendingPathComponent("Diagnostics").path)
        XCTAssertTrue(fileUrls.count > 0)
    }

    func testDivideAttachmentsWithUTIFlags() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testSuccess", type: "xcresult")
        xcparseProcess.arguments = ["attachments",file.url.path,temporaryOutputDirectoryURL.path,"--uti", "public.plain-text","public.image"]

        try runAndWaitForXCParseProcess()
        let fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.path)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_todayWidget")}.count == 3)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("MyAutomation_darkMapView")}.count == 3)
    }

    func testGetTestsWithFailure() throws {
        guard #available(macOS 10.13, *) else {
            return
        }

        let file = try Resource(name: "testFailure", type: "xcresult")
        xcparseProcess.arguments = ["screenshots",file.url.path,temporaryOutputDirectoryURL.path,"--test-status", "Failure"]

        try runAndWaitForXCParseProcess()
        let fileUrls = FileManager.default.listFiles(path: temporaryOutputDirectoryURL.path)
        XCTAssertTrue(fileUrls.filter{$0.path.contains("Screenshot")}.count == 12)
    }
    

    lazy var xcparseProcess: Process  = {
        let fooBinary = productsDirectory.appendingPathComponent("xcparse")
        let process = Process()
        process.executableURL = fooBinary
        return process
    }()

    /// Returns path to the built products directory.
    var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }

    func runAndWaitForXCParseProcess() throws  {
        try xcparseProcess.run()
        xcparseProcess.waitUntilExit()
    }

    lazy var temporaryOutputDirectoryURL:URL  = {
        // Setup a temp test folder that can be used as a sandbox
        let tempDirectoryURL = FileManager.default.temporaryDirectory
        let temporaryOutputDirectoryName = ProcessInfo().globallyUniqueString
        let temporaryOutputDirectoryURL =
            tempDirectoryURL.appendingPathComponent(temporaryOutputDirectoryName)
        return temporaryOutputDirectoryURL
    }()

    static var allTests = [
        ("testScreenshots", testScreenshots),("testDivideByTestPlanConfig",testDivideByTestPlanConfig)
    ]
}
