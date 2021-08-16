//
//  ActionTestSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2021 ChargePoint, Inc. All rights reserved.
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
    public let skipNoticeSummary: ActionTestNoticeSummary?
    public let activitySummaries: [ActionTestActivitySummary]

    // xcresult 3.34 and above
    public let expectedFailures: [ActionTestExpectedFailure]
    public let repetitionPolicySummary: ActionTestRepetitionPolicySummary?
    public let configuration: ActionTestConfiguration?

    enum ActionTestSummaryCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case performanceMetrics
        case failureSummaries
        case skipNoticeSummary
        case activitySummaries
        case expectedFailures
        case repetitionPolicySummary
        case configuration
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)

        performanceMetrics = try container.decodeXCResultArray(forKey: .performanceMetrics)
        failureSummaries = try container.decodeXCResultArray(forKey: .failureSummaries)
        skipNoticeSummary = try container.decodeXCResultObjectIfPresent(forKey: .skipNoticeSummary)
        activitySummaries = try container.decodeXCResultArray(forKey: .activitySummaries)

        expectedFailures = try container.decodeXCResultArray(forKey: .expectedFailures)
        repetitionPolicySummary = try container.decodeXCResultObjectIfPresent(forKey: .repetitionPolicySummary)
        configuration = try container.decodeXCResultObjectIfPresent(forKey: .configuration)

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
}
