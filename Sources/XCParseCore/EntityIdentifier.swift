//
//  EntityIdentifier.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class EntityIdentifier : Codable {
    public let entityName: String
    public let containerName: String
    public let entityType: String
    public let sharedState: String

    enum EntityIdentifierCodingKeys: String, CodingKey {
        case entityName
        case containerName
        case entityType
        case sharedState
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        entityName = try container.decodeXCResultType(forKey: .entityName)
        containerName = try container.decodeXCResultType(forKey: .containerName)
        entityType = try container.decodeXCResultType(forKey: .entityType)
        sharedState = try container.decodeXCResultType(forKey: .sharedState)
    }
}
