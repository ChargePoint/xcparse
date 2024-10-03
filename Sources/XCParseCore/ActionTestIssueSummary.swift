//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation
open class ActionTestIssueSummary: Codable {
    public let message: String?
    public let fileName: String
    public let lineNumber: Int
    public let uuid: String
    public let issueType: String?
    public let detailedDescription: String?
    public let attachments: [ActionTestAttachment]
    public let associatedError: TestAssociatedError?
    public let sourceCodeContext: SourceCodeContext?
    public let timestamp: Date?
    
    enum ActionTestIssueSummaryCodingKeys: String, CodingKey {
        case message
        case fileName
        case lineNumber
        case uuid
        case issueType
        case detailedDescription
        case attachments
        case associatedError
        case sourceCodeContext
        case timestamp
    }
    
    required public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeXCResultTypeIfPresent(forKey: .message)
        self.fileName = try container.decodeXCResultType(forKey: .fileName)
        self.lineNumber = try container.decodeXCResultType(forKey: .lineNumber)
        self.uuid = try container.decodeXCResultType(forKey: .uuid)
        self.issueType = try container.decodeXCResultTypeIfPresent(forKey: .issueType)
        self.detailedDescription = try container.decodeXCResultTypeIfPresent(forKey: .detailedDescription)
        self.attachments = try container.decodeXCResultType(forKey: .attachments)
        self.associatedError = try container.decodeXCResultTypeIfPresent(forKey: .associatedError)
        self.sourceCodeContext = try container.decodeXCResultTypeIfPresent(forKey: .sourceCodeContext)
        self.timestamp = try container.decodeXCResultTypeIfPresent(forKey: .timestamp)
    }
}
