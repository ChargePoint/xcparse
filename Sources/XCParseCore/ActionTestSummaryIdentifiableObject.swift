//
//  ActionTestSummaryIdentifiableObject.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestSummaryIdentifiableObject : ActionAbstractTestSummary {
    public let identifier: String?

    enum ActionTestSummaryIdentifiableObjectCodingKeys: String, CodingKey {
        case identifier
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryIdentifiableObjectCodingKeys.self)
        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        try super.init(from: decoder)
    }
}
