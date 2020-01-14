//
//  ActionTestSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

public enum TestStatus : String {
    case Success
    case Failure
}

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

    public func allChildActivitySummaries() -> [ActionTestActivitySummary] {
        var activitySummaries = self.activitySummaries

        var summariesToCheck = activitySummaries
        repeat {
            summariesToCheck = summariesToCheck.flatMap { $0.subactivities }

            // Add the subactivities we found
            activitySummaries.append(contentsOf: summariesToCheck)
        } while summariesToCheck.count > 0

        return activitySummaries
    }

    public func allDFSChildActivitySummaries() -> [ActionTestActivitySummary] {
        var activitySummaries: [ActionTestActivitySummary] = []

        var summariesToCheck = self.activitySummaries
        summariesToCheck.reverse()
        repeat {
            guard let summary = summariesToCheck.popLast() else {
                continue
            }
            activitySummaries.append(summary)

            // Let's add the subactivities in now
            var subactivities = summary.subactivities
            subactivities.reverse()
            summariesToCheck.append(contentsOf: subactivities)
        } while summariesToCheck.isEmpty != true

        return activitySummaries
    }
}
