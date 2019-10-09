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

        performanceMetrics = try container.decodeXCResultArray(forKey: .performanceMetrics)
        failureSummaries = try container.decodeXCResultArray(forKey: .failureSummaries)
        activitySummaries = try container.decodeXCResultArray(forKey: .activitySummaries)

        try super.init(from: decoder)
    }
}
