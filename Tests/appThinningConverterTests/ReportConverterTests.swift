//
//  ReportConverterTests.swift
//  AppThinningConverterTests
//
//  Created by Vido Shaweddy on 4/1/21.
//

import XCTest
@testable import Converter
@testable import testUtility

final class ReportConverterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testParseTextReturnsExpected() throws {
        let bundle = Bundle(for: type(of: self))
        
        let filepath = try Resource(name: "App Thinning Size Report", type: "txt")
        let file = try String(contentsOfFile: filepath.url.path)
        let text = try XCTUnwrap(file)

        let jsonPath = try Resource(name: "appThinningSizeReport", type: "json")
        let data = try Data(contentsOf: jsonPath.url, options: .mappedIfSafe)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let result = ReportConverter.parse(text: text)
        
        let expectation = try decoder.decode([VariantModel].self, from: data)

        XCTAssertEqual(result, expectation)
    }
}
