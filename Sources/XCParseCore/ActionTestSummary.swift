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
    public let expectedFailures: [ActionTestExpectedFailure]
    public let skipNoticeSummary: ActionTestNoticeSummary?
    public let activitySummaries: [ActionTestActivitySummary]
    public let repetitionPolicySummary: ActionTestRepetitionPolicySummary?
    public let arguments: [TestArgument]
    public let configuration: ActionTestConfiguration?
    public let warningSummaries: [ActionTestIssueSummary]
    public let summary: String?
    public let documentation: [TestDocumentation]
    public let trackedIssues: [IssueTrackingMetadata]
    public let tags: [TestTag]

    enum ActionTestSummaryCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case performanceMetrics
        case failureSummaries
        case expectedFailures
        case skipNoticeSummary
        case activitySummaries
        case repetitionPolicySummary
        case arguments
        case configuration
        case warningSummaries
        case summary
        case documentation
        case trackedIssues
        case tags
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)

        performanceMetrics = try container.decodeXCResultArray(forKey: .performanceMetrics)
        failureSummaries = try container.decodeXCResultArray(forKey: .failureSummaries)
        expectedFailures = try container.decodeXCResultArray(forKey: .expectedFailures)
        skipNoticeSummary = try container.decodeXCResultObjectIfPresent(forKey: .skipNoticeSummary)
        activitySummaries = try container.decodeXCResultArray(forKey: .activitySummaries)
        repetitionPolicySummary = try container.decodeXCResultObjectIfPresent(forKey: .repetitionPolicySummary)
        arguments = try container.decodeXCResultArray(forKey: .arguments)
        configuration = try container.decodeXCResultObjectIfPresent(forKey: .configuration)
        warningSummaries = try container.decodeXCResultArray(forKey: .warningSummaries)
        summary = try container.decodeXCResultTypeIfPresent(forKey: .summary)
        documentation = try container.decodeXCResultArray(forKey: .documentation)
        trackedIssues = try container.decodeXCResultArray(forKey: .trackedIssues)
        tags = try container.decodeXCResultArray(forKey: .tags)

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
