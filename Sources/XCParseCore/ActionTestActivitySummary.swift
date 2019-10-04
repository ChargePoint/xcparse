//
//  ActionTestActivitySummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestActivitySummary : Codable {
    public let title: String
    public let activityType: String
    public let uuid: String
    public let start: Date?
    public let finish: Date?
    public let attachments: [ActionTestAttachment]
    public let subactivities: [ActionTestActivitySummary]

    enum ActionTestActivitySummaryCodingKeys: String, CodingKey {
        case title
        case activityType
        case uuid
        case start
        case finish
        case attachments
        case subactivities
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestActivitySummaryCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        activityType = try container.decodeXCResultType(forKey: .activityType)
        uuid = try container.decodeXCResultType(forKey: .uuid)
        start = try container.decodeXCResultTypeIfPresent(forKey: .start)
        finish = try container.decodeXCResultTypeIfPresent(forKey: .finish)

        attachments = try container.decodeIfPresent(XCResultArrayValue<ActionTestAttachment>.self, forKey: .attachments)?.values ?? []
        subactivities = try container.decodeIfPresent(XCResultArrayValue<ActionTestActivitySummary>.self, forKey: .subactivities)?.values ?? []
    }
}
