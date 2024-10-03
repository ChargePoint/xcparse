//
//  ActionTestSummaryGroup.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestSummaryGroup : ActionTestSummaryIdentifiableObject {
    public let duration: Double
    public let subtests: [ActionTestSummaryIdentifiableObject]
    public let skipNoticeSummary: ActionTestNoticeSummary?
    public let summary: String?
    public let documentation: [TestDocumentation]
    public let trackedIssues: [IssueTrackingMetadata]
    public let tags: [TestTag]

    enum ActionTestSummaryGroupCodingKeys: String, CodingKey {
        case duration
        case subtests
        case skipNoticeSummary
        case summary
        case documentation
        case trackedIssues
        case tags
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryGroupCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)
        subtests = try container.decodeXCResultArray(forKey: .subtests)
        skipNoticeSummary = try container.decodeXCResultTypeIfPresent(forKey: .skipNoticeSummary)
        summary = try container.decodeXCResultTypeIfPresent(forKey: .summary)
        documentation = try container.decodeXCResultArray(forKey: .documentation)
        trackedIssues = try container.decodeXCResultArray(forKey: .trackedIssues)
        tags = try container.decodeXCResultArray(forKey: .tags)
        try super.init(from: decoder)
    }
}
