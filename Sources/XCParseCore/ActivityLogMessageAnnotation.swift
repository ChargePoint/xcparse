//
//  ActivityLogMessageAnnotation.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogMessageAnnotation : Codable {
    public let title: String
    public let location: DocumentLocation?

    enum ActivityLogMessageCodingKeys: String, CodingKey {
        case title
        case location
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogMessageCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
    }
}
