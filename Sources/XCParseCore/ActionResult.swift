//
//  ActionResult.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionResult : Codable {
    public let resultName: String
    public let status: String
    public let metrics: ResultMetrics
    public let issues: ResultIssueSummaries
    public let coverage: CodeCoverageInfo
    public let timelineRef: Reference?
    public let logRef: Reference?
    public let testsRef: Reference?
    public let diagnosticsRef: Reference?
    
    // xcresult 3.39 and above
    public let consoleLogRef: Reference?

    enum ActionResultCodingKeys: String, CodingKey {
        case resultName
        case status
        case metrics
        case issues
        case coverage
        case timelineRef
        case logRef
        case testsRef
        case diagnosticsRef
        case consoleLogRef
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionResultCodingKeys.self)
        resultName = try container.decodeXCResultType(forKey: .resultName)
        status = try container.decodeXCResultType(forKey: .status)
        metrics = try container.decodeXCResultObject(forKey: .metrics)
        issues = try container.decodeXCResultObject(forKey: .issues)
        coverage = try container.decodeXCResultObject(forKey: .coverage)
        timelineRef = try container.decodeXCResultObjectIfPresent(forKey: .timelineRef)
        logRef = try container.decodeXCResultObjectIfPresent(forKey: .logRef)
        testsRef = try container.decodeXCResultObjectIfPresent(forKey: .testsRef)
        diagnosticsRef = try container.decodeXCResultObjectIfPresent(forKey: .diagnosticsRef)
        consoleLogRef = try container.decodeXCResultObjectIfPresent(forKey: .consoleLogRef)
    }
}
