//
//  ScreenshotCommandTests.swift
//  
//
//  Created by Alexander Botkin on 6/30/20.
//

import XCTest
import class Foundation.Bundle

final class ScreenshotCommandTests: XCTestCase {
    func testScreenshotUTIFilter() throws {
        let imageUTIs = [
            "public.heic",
            "public.heif",
            "public.png",
            "public.jpeg",
            "com.compuserve.gif",
        ]

        for UTI in imageUTIs {
            let conformsAsImage = UTTypeConformsTo(UTI as CFString, "public.image" as CFString)
            XCTAssertTrue(conformsAsImage, "\(UTI) does not conform to public.image UTI. Screenshots command will not extract")
        }

        let nonImageUTIs = [
            "public.plain-text",
            "com.adobe.pdf",
        ]

        for UTI in nonImageUTIs {
            let conformsAsImage = UTTypeConformsTo(UTI as CFString, "public.image" as CFString)
            XCTAssertFalse(conformsAsImage, "\(UTI) unexpectedly conforms to public.image UTI. Screenshots command will extract this")
        }
    }

    static var allTests = [
        ("testScreenshotUTIFilter", testScreenshotUTIFilter),
    ]
}
