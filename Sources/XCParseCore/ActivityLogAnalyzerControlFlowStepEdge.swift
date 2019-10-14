//
//  ActivityLogAnalyzerControlFlowStepEdge.swift
//  XCParseCore
//
//  Created by Alexander Botkin on 10/9/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogAnalyzerControlFlowStepEdge : Codable {
    public let startLocation: DocumentLocation?
    public let endLocation: DocumentLocation?

    enum ActivityLogAnalyzerControlFlowStepEdgeCodingKeys: String, CodingKey {
        case startLocation
        case endLocation
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogAnalyzerControlFlowStepEdgeCodingKeys.self)

        startLocation = try container.decodeXCResultObjectIfPresent(forKey: .startLocation)
        endLocation = try container.decodeXCResultObjectIfPresent(forKey: .endLocation)
    }
}
