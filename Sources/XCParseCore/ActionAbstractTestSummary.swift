//
//  ActionAbstractTestSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionAbstractTestSummary : Codable {
    public let name: String?

    enum ActionAbstractTestSummaryCodingKeys: String, CodingKey {
        case name
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionAbstractTestSummaryCodingKeys.self)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
    }
}
