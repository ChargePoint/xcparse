//
//  ActivityLogSection.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogSection : Codable {
    public let domainType: String
    public let title: String
    public let startTime: Date?
    public let duration: Double
    public let result: String?
    public let subsections: [ActivityLogSection]
    public let messages: [ActivityLogMessage]

    enum ActivityLogSectionCodingKeys: String, CodingKey {
        case domainType
        case title
        case startTime
        case duration
        case result
        case subsections
        case messages
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogSectionCodingKeys.self)
        domainType = try container.decodeXCResultType(forKey: .domainType)
        title = try container.decodeXCResultType(forKey: .title)
        startTime = try container.decodeXCResultTypeIfPresent(forKey: .startTime)
        duration = try container.decodeXCResultType(forKey: .duration)
        result = try container.decodeXCResultTypeIfPresent(forKey: .result)

        let subsectionValues = try container.decode(XCResultArrayValue<ActivityLogSection>.self, forKey: .subsections)
        subsections = subsectionValues.values

        let messageValues = try container.decode(XCResultArrayValue<ActivityLogMessage>.self, forKey: .messages)
        messages = messageValues.values
    }
}
