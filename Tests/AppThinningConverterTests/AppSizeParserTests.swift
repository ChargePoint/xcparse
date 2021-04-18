//
//  AppSizeParserTests.swift
//  AppThinningConverterTests
//
//  Created by Vido Shaweddy on 4/1/21.
//

import XCTest
@testable import AppThinningConverter

class AppSizeParserTests: XCTestCase {
    func testParseTextReturnsExpected() throws {
        let text = "11.6 MB compressed, 12.9 MB uncompressed"
        let parser = AppSizeParser(text: text)
        let expectation = AppSizeModel(compressed: SizeModel(rawValue: "11.6 MB", value: 11.6, unit: .megabytes),
                                       uncompressed: SizeModel(rawValue: "12.9 MB", value: 12.9, unit: .megabytes))
        let result = try XCTUnwrap(parser.result)
        XCTAssertEqual(result, expectation)
    }

    func testParseZeroTextReturnsExpected() throws {
        let text = "Zero KB compressed, Zero KB uncompressed"
        let parser = AppSizeParser(text: text)
        let expectation = AppSizeModel(compressed: SizeModel(rawValue: "0 KB", value: 0.0, unit: .megabytes),
                                       uncompressed: SizeModel(rawValue: "0 KB", value: 0.0, unit: .megabytes))
        let result = try XCTUnwrap(parser.result)
        XCTAssertEqual(result, expectation)
    }
}
