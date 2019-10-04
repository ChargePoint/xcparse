//
//  ActionTestSummaryGroup.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestSummaryGroup : ActionTestSummaryIdentifiableObject {
    public let duration: Double
    public let subtests: [ActionTestSummaryIdentifiableObject]

    enum ActionTestSummaryGroupCodingKeys: String, CodingKey {
        case duration
        case subtests
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestSummaryGroupCodingKeys.self)
        duration = try container.decodeXCResultType(forKey: .duration)

        let subtestsValues = try container.decode(XCResultArrayValue<ActionTestSummaryIdentifiableObject>.self, forKey: .subtests)
        subtests = subtestsValues.values
        try super.init(from: decoder)
    }
}
