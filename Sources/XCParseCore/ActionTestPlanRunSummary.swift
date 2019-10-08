//
//  ActionTestPlanRunSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestPlanRunSummary : ActionAbstractTestSummary {
    public let testableSummaries: [ActionTestableSummary]

    enum ActionTestPlanRunSummaryCodingKeys: String, CodingKey {
        case testableSummaries
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummaryCodingKeys.self)

        testableSummaries = try container.decodeXCResultArray(forKey: .testableSummaries)

        try super.init(from: decoder)
    }
}
