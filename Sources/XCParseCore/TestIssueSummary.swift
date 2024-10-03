//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestIssueSummary: Codable {
    public let testCaseName: String

    enum TestIssueSummaryCodingKeys: String, CodingKey {
        case testCaseName
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestIssueSummaryCodingKeys.self)
        testCaseName = try container.decodeXCResultType(forKey: .testCaseName)
    }
}
