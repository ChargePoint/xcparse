//
//  ActionTestExpectedFailure.swift
//  XCParseCore
//
//  Created by Alex Botkin on 8/16/21.
//  Copyright © 2021 ChargePoint, Inc. All rights reserved.
//

import Foundation

// xcresult 3.34 and above
open class ActionTestExpectedFailure : Codable {
    public let uuid: String
    public let failureReason: String?
    public let failureSummary: ActionTestFailureSummary?
    public let isTopLevelFailure: Bool

    enum ActionTestExpectedFailureCodingKeys: String, CodingKey {
        case uuid
        case failureReason
        case failureSummary
        case isTopLevelFailure
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestExpectedFailureCodingKeys.self)

        uuid = try container.decodeXCResultType(forKey: .uuid)
        failureReason = try container.decodeXCResultTypeIfPresent(forKey: .failureReason)
        failureSummary = try container.decodeXCResultObjectIfPresent(forKey: .failureSummary)
        isTopLevelFailure = try container.decodeXCResultType(forKey: .isTopLevelFailure)
    }
}
