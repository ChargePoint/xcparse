//
//  ActivityLogAnalyzerControlFlowStep.swift
//  XCParseCore
//
//  Created by Alexander Botkin on 10/9/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogAnalyzerControlFlowStep : ActivityLogAnalyzerStep {
    public let title: String
    public let startLocation: DocumentLocation?
    public let endLocation: DocumentLocation?
    public let edges: [ActivityLogAnalyzerControlFlowStepEdge]

    enum ActivityLogAnalyzerControlFlowStepCodingKeys: String, CodingKey {
        case title
        case startLocation
        case endLocation
        case edges
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogAnalyzerControlFlowStepCodingKeys.self)

        title = try container.decodeXCResultType(forKey: .title)
        startLocation = try container.decodeXCResultObjectIfPresent(forKey: .startLocation)
        endLocation = try container.decodeXCResultObjectIfPresent(forKey: .endLocation)
        edges = try container.decodeXCResultArray(forKey: .edges)

        try super.init(from: decoder)
    }
}
