//
//  ActionTestRepetitionPolicySummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 8/16/21.
//  Copyright © 2021 ChargePoint, Inc. All rights reserved.
//

import Foundation

// xcresult 3.34 and above
open class ActionTestRepetitionPolicySummary : Codable {
    public let iteration: Int?
    public let totalIterations: Int?
    public let repetitionMode: String?

    enum ActionTestRepetitionPolicySummaryCodingKeys: String, CodingKey {
        case iteration
        case totalIterations
        case repetitionMode
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestRepetitionPolicySummaryCodingKeys.self)

        iteration = try container.decodeXCResultTypeIfPresent(forKey: .iteration)
        totalIterations = try container.decodeXCResultTypeIfPresent(forKey: .totalIterations)
        repetitionMode = try container.decodeXCResultTypeIfPresent(forKey: .repetitionMode)
    }
}
