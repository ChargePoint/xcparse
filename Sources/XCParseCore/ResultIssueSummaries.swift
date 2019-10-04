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
        analyzerWarningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .analyzerWarningSummaries)?.values ?? []
        errorSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .errorSummaries)?.values ?? []
        testFailureSummaries = try container.decodeIfPresent(XCResultArrayValue<TestFailureIssueSummary>.self, forKey: .testFailureSummaries)?.values ?? []
        warningSummaries = try container.decodeIfPresent(XCResultArrayValue<IssueSummary>.self, forKey: .warningSummaries)?.values ?? []
    }
}
