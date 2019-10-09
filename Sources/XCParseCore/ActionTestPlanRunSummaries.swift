//
//  ActionTestPlanRunSummaries.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestPlanRunSummaries : Codable {
    public let summaries: [ActionTestPlanRunSummary]

    enum ActionTestPlanRunSummariesCodingKeys: String, CodingKey {
        case summaries
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestPlanRunSummariesCodingKeys.self)
        summaries = try container.decodeXCResultArray(forKey: .summaries)
    }
}
