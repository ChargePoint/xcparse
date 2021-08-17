//
//  ActionTestActivitySummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

public enum ActionTestActivityType : String {
    case attachmentContainer = "com.apple.dt.xctest.activity-type.attachmentContainer"
    case deletedAttachment = "com.apple.dt.xctest.activity-type.deletedAttachment"
    case `internal` = "com.apple.dt.xctest.activity-type.internal"
    case testAssertionFailure = "com.apple.dt.xctest.activity-type.testAssertionFailure"
    case userCreated = "com.apple.dt.xctest.activity-type.userCreated"
}

open class ActionTestActivitySummary : Codable {
    public let title: String
    public let activityType: String
    public let uuid: String
    public let start: Date?
    public let finish: Date?
    public let attachments: [ActionTestAttachment]
    public let subactivities: [ActionTestActivitySummary]

    // xcresult 3.26 and above
    public let failureSummaryIDs: [String]

    // xcresult 3.34 and above
    public let expectedFailureIDs: [String]

    enum ActionTestActivitySummaryCodingKeys: String, CodingKey {
        case title
        case activityType
        case uuid
        case start
        case finish
        case attachments
        case subactivities
        case failureSummaryIDs
        case expectedFailureIDs
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestActivitySummaryCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        activityType = try container.decodeXCResultType(forKey: .activityType)
        uuid = try container.decodeXCResultType(forKey: .uuid)
        start = try container.decodeXCResultTypeIfPresent(forKey: .start)
        finish = try container.decodeXCResultTypeIfPresent(forKey: .finish)

        attachments = try container.decodeXCResultArray(forKey: .attachments)
        subactivities = try container.decodeXCResultArray(forKey: .subactivities)
        failureSummaryIDs = try container.decodeXCResultArray(forKey: .failureSummaryIDs)
        expectedFailureIDs = try container.decodeXCResultArray(forKey: .expectedFailureIDs)
    }
}
