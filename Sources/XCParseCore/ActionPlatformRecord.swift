//
//  ActionPlatformRecord.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionPlatformRecord : Codable {
    public let identifier: String
    public let userDescription: String

    enum ActionPlatformRecordCodingKeys: String, CodingKey {
        case identifier
        case userDescription
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionPlatformRecordCodingKeys.self)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        userDescription = try container.decodeXCResultType(forKey: .userDescription)
    }
}
