//
//  DocumentLocation.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class DocumentLocation : Codable {
    public let url: String
    public let concreteTypeName: String

    enum DocumentLocationCodingKeys: String, CodingKey {
        case url
        case concreteTypeName
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DocumentLocationCodingKeys.self)
        url = try container.decodeXCResultType(forKey: .url)
        concreteTypeName = try container.decodeXCResultType(forKey: .concreteTypeName)
    }
}
