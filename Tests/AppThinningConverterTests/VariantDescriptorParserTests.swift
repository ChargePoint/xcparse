//
//  VariantDescriptorParser.swift
//  AppThinningConverterTests
//
//  Created by Vido Shaweddy on 4/1/21.
//

import XCTest
@testable import AppThinningConverter

class VariantDescriptorParserTests: XCTestCase {
    func testParseTextReturnsExpected() throws {
        let text = "[device: iPhone8,4, os-version: 14.0], [device: iPhone8,1, os-version: 14.0], and [device: iPod9,1, os-version: 14.0]"
        let parser = VariantDescriptorParser(text: text)
        let expectation = [
            DeviceModel(device: "iPhone8,4", osVersion: "14.0"),
            DeviceModel(device: "iPhone8,1", osVersion: "14.0"),
            DeviceModel(device: "iPod9,1", osVersion: "14.0")
        ]
        let result = try XCTUnwrap(parser.result)
        XCTAssertEqual(result, expectation)
    }

    func testParseTextReturnsEmpty() throws {
        let text = "device: iPhone8,4, os-version: 14.0, device: iPhone8,1, os-version: 14.0, and device: iPod9,1, os-version: 14.0"
        let parser = VariantDescriptorParser(text: text)
        let expectation = [DeviceModel]()
        let result = try XCTUnwrap(parser.result)
        XCTAssertEqual(result, expectation)
    }
}
