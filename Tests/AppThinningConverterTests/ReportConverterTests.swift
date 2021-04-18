//
//  ReportConverterTests.swift
//  AppThinningConverterTests
//
//  Created by Vido Shaweddy on 4/1/21.
//

import XCTest
@testable import AppThinningConverter

class ReportConverterTests: XCTestCase {
    var converter: ReportConverter!

    override func setUp() {
        super.setUp()
        converter = ReportConverter()
    }

    func testParseTextReturnsExpected() throws {
        let bundle = Bundle(for: type(of: self))
        let filepath = try XCTUnwrap(bundle.path(forResource: "App Thinning Size Report", ofType: "txt"))
        let file = try String(contentsOfFile: filepath)
        let text = try XCTUnwrap(file)

        let path = try XCTUnwrap(bundle.url(forResource: "ExpectedResult", withExtension: "json"))
        let data = try Data(contentsOf: path, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = converter.parse(text: text)
        let expectation = try decoder.decode([VariantModel].self, from: data)

        XCTAssertEqual(result, expectation)
    }
}
