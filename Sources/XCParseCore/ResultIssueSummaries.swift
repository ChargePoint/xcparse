//
//  ResultIssueSummaries.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ResultIssueSummaries : Codable {
    public let analyzerWarningSummaries: [IssueSummary]
    public let errorSummaries: [IssueSummary]
    public let testFailureSummaries: [TestFailureIssueSummary]
    public let warningSummaries: [IssueSummary]

    enum ResultIssueSummariesCodingKeys: String, CodingKey {
        case analyzerWarningSummaries
        case errorSummaries
        case testFailureSummaries
        case warningSummaries
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultIssueSummariesCodingKeys.self)
        analyzerWarningSummaries = try container.decodeXCResultArray(forKey: .analyzerWarningSummaries)
        errorSummaries = try container.decodeXCResultArray(forKey: .errorSummaries)
        testFailureSummaries = try container.decodeXCResultArray(forKey: .testFailureSummaries)
        warningSummaries = try container.decodeXCResultArray(forKey: .warningSummaries)
    }
}
