//
//  ConsoleLogSection.swift
//  XCParseCore
//
//  Created by Rishab Sukumar on 8/11/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.

import Foundation

// xcresult 3.39 and above
open class ConsoleLogSection : Codable {
    public let title: String
    public let items: [ConsoleLogItem]

    enum ConsoleLogSectionCodingKeys: String, CodingKey {
        case title
        case items
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConsoleLogSectionCodingKeys.self)
        title = try container.decodeXCResultType(forKey: .title)
        items = try container.decodeXCResultArray(forKey: .items)
    }
}
