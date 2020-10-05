//
//  ActionTestFailureSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestFailureSummary : Codable {
    public let message: String?
    public let fileName: String
    public let lineNumber: Int
    public let isPerformanceFailure: Bool

    // xcresult 3.26 and above
    public let uuid: String
    public let issueType: String?
    public let detailedDescription: String?
    public let attachments: [ActionTestAttachment] // TODO: Alex - look into whether we need to parse from this for screenshots command
    public let associatedError: TestAssociatedError?
    public let sourceCodeContext: SourceCodeContext?
    public let timestamp: Date?
    public let isTopLevelFailure: Bool

    enum ActionTestFailureSummaryCodingKeys: String, CodingKey {
        case message
        case fileName
        case lineNumber
        case isPerformanceFailure
        // xcresult 3.26 and above
        case uuid
        case issueType
        case detailedDescription
        case attachments
        case associatedError
        case sourceCodeContext
        case timestamp
        case isTopLevelFailure
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestFailureSummaryCodingKeys.self)
        message = try container.decodeXCResultTypeIfPresent(forKey: .message)
        fileName = try container.decodeXCResultType(forKey: .fileName)
        lineNumber = try container.decodeXCResultType(forKey: .lineNumber)
        isPerformanceFailure = try container.decodeXCResultType(forKey: .isPerformanceFailure)

        uuid = try container.decodeXCResultType(forKey: .uuid)
        issueType = try container.decodeXCResultTypeIfPresent(forKey: .issueType)
        detailedDescription = try container.decodeXCResultTypeIfPresent(forKey: .detailedDescription)
        attachments = try container.decodeXCResultArray(forKey: .attachments)
        associatedError = try container.decodeXCResultObjectIfPresent(forKey: .associatedError)
        sourceCodeContext = try container.decodeXCResultObjectIfPresent(forKey: .sourceCodeContext)
        timestamp = try container.decodeXCResultTypeIfPresent(forKey: .timestamp)
        isTopLevelFailure = try container.decodeXCResultType(forKey: .isTopLevelFailure)
    }
}
