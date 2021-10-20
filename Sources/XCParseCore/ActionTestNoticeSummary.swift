//
//  ActionTestNoticeSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 8/16/21.
//  Copyright © 2021 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestNoticeSummary : Codable {
    public let message: String?
    public let fileName: String
    public let lineNumber: Int

    enum ActionTestNoticeSummaryCodingKeys: String, CodingKey {
        case message
        case fileName
        case lineNumber
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestNoticeSummaryCodingKeys.self)

        message = try container.decodeXCResultTypeIfPresent(forKey: .message)
        fileName = try container.decodeXCResultType(forKey: .fileName)
        lineNumber = try container.decodeXCResultType(forKey: .lineNumber)
    }
}
