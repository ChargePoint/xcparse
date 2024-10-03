//
//  ConsoleLogItem.swift
//  XCParseCore
//
//  Created by Rishab Sukumar on 8/11/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.

import Foundation

// xcresult 3.39 and above
open class ConsoleLogItem : Codable {
    public let adaptorType: String?
    public let kind: String?
    public let timestamp: Double
    public let content: String
    public let logData: ConsoleLogItemLogData?

    enum ConsoleLogItemCodingKeys: String, CodingKey {
        case adaptorType
        case kind
        case timestamp
        case content
        case logData
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConsoleLogItemCodingKeys.self)
        adaptorType = try container.decodeXCResultTypeIfPresent(forKey: .adaptorType)
        kind = try container.decodeXCResultTypeIfPresent(forKey: .kind)
        timestamp = try container.decodeXCResultType(forKey: .timestamp)
        content = try container.decodeXCResultType(forKey: .content)
        logData = try container.decodeXCResultTypeIfPresent(forKey: .logData)
    }
}

