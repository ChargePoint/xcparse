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

    public func attachments(filterActivitySummaries: (ActionTestActivitySummary) -> Bool = { _ in return true }) -> [ActionTestAttachment] {
        var activitySummaries = self.activitySummaries

        var summariesToCheck = activitySummaries
        repeat {
            summariesToCheck = summariesToCheck.flatMap { $0.subactivities }

            // Add the subactivities we found
            activitySummaries.append(contentsOf: summariesToCheck)
        } while summariesToCheck.count > 0

        let filteredActivitySummaries = activitySummaries.filter(filterActivitySummaries)
        return filteredActivitySummaries.flatMap { $0.attachments }
    }
}
