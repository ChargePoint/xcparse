//
//  ActionTestMetadata.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestMetadata : ActionTestSummaryIdentifiableObject {
    public let testStatus: String
    public let duration: Double?
    public let summaryRef: Reference?
    public let performanceMetricsCount: Int
    public let failureSummariesCount: Int
    public let activitySummariesCount: Int

    enum ActionTestMetadataCodingKeys: String, CodingKey {
        case testStatus
        case duration
        case summaryRef
        case performanceMetricsCount
        case failureSummariesCount
        case activitySummariesCount
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestMetadataCodingKeys.self)
        testStatus = try container.decodeXCResultType(forKey: .testStatus)
        duration = try container.decodeXCResultTypeIfPresent(forKey: .duration)
        summaryRef = try container.decodeXCResultObjectIfPresent(forKey: .summaryRef)
        performanceMetricsCount = try container.decodeXCResultType(forKey: .performanceMetricsCount)
        failureSummariesCount = try container.decodeXCResultType(forKey: .failureSummariesCount)
        activitySummariesCount = try container.decodeXCResultType(forKey: .activitySummariesCount)

        try super.init(from: decoder)
    }
}
