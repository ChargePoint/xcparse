//
//  ArchiveInfo.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ArchiveInfo : Codable {
    public let path: String?

    enum ArchiveInfoCodingKeys: String, CodingKey {
        case path
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArchiveInfoCodingKeys.self)
        path = try container.decodeXCResultTypeIfPresent(forKey: .path)
    }
}
