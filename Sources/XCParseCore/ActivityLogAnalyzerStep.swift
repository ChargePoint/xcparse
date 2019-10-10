//
//  ActivityLogAnalyzerStep.swift
//  XCParseCore
//
//  Created by Alexander Botkin on 10/9/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogAnalyzerStep : Codable {
    public let parentIndex: Int

    enum ActivityLogAnalyzerStepCodingKeys: String, CodingKey {
        case parentIndex
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogAnalyzerStepCodingKeys.self)
        parentIndex = try container.decodeXCResultType(forKey: .parentIndex)
    }
}
