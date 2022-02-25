//
//  VariantParserTests.swift
//  AppThinningConverterTests
//
//  Created by Vido Shaweddy on 4/1/21.
//

import XCTest
@testable import Converter

final class VariantParserTests: XCTestCase {
    func testParseTextReturnsExpected() throws {
        let text = "ChargePointAppClip-0F01226A-99F0-4092-8BBD-6919103E6F0A.ipa"
        let parser = VariantParser(text: text)
        let result = try XCTUnwrap(parser.result)
        XCTAssertEqual(result, text)
    }
}
