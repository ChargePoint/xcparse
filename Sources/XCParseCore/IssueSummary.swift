//
//  IssueSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class IssueSummary : Codable {
    public let issueType: String
    public let message: String
    public let producingTarget: String?
    public let documentLocationInCreatingWorkspace: DocumentLocation?

    enum EntityIdentifierCodingKeys: String, CodingKey {
        case issueType
        case message
        case producingTarget
        case documentLocationInCreatingWorkspace
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: EntityIdentifierCodingKeys.self)
        issueType = try container.decodeXCResultType(forKey: .issueType)
        message = try container.decodeXCResultType(forKey: .message)
        producingTarget = try container.decodeXCResultTypeIfPresent(forKey: .producingTarget)
        documentLocationInCreatingWorkspace = try container.decodeXCResultObjectIfPresent(forKey: .documentLocationInCreatingWorkspace)
    }
}
