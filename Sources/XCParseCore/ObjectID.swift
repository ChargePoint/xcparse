//
//  ObjectID.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ObjectID : Codable {
    public let hash: String

    enum ObjectIDCodingKeys: String, CodingKey {
        case hash
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ObjectIDCodingKeys.self)
        hash = try container.decodeXCResultType(forKey: .hash)
    }
}
