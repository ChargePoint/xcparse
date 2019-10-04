//
//  TestFailureIssueSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class TestFailureIssueSummary : IssueSummary {
    public let testCaseName: String

    enum TestFailureIssueSummaryCodingKeys: String, CodingKey {
        case testCaseName
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestFailureIssueSummaryCodingKeys.self)
        testCaseName = try container.decodeXCResultType(forKey: .testCaseName)
        try super.init(from: decoder)
    }
}
