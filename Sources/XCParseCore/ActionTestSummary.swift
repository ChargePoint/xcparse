//
//  ActionTestSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestSummary : ActionTestSummaryIdentifiableObject {
    public let testStatus: String
    public let duration: Double
    public let performanceMetrics: [ActionTestPerformanceMetricSummary]
    public let failureSummaries: [ActionTestFailureSummary]
    public let activitySummaries: [ActionTestActivitySummary]

    enum ActionTestSummaryCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case performanceMetrics
        case failureSummaries
        case activitySummaries
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)

        performanceMetrics = try container.decodeIfPresent(XCResultArrayValue<ActionTestPerformanceMetricSummary>.self, forKey: .performanceMetrics)?.values ?? []
        failureSummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestFailureSummary>.self, forKey: .failureSummaries)?.values ?? []
        activitySummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .activitySummaries)?.values ?? []

        try super.init(from: decoder)
    }
}
