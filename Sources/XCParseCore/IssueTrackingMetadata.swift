//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation
open class IssueTrackingMetadata: Codable {
    public let identifier: String
    public let url: URL?
    public let comment: String?
    public let summary: String

    enum IssueTrackingMetadataCodingKeys: String, CodingKey {
        case identifier
        case url
        case comment
        case summary
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IssueTrackingMetadataCodingKeys.self)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        url = try container.decodeXCResultTypeIfPresent(forKey: .url)
        comment = try container.decodeXCResultTypeIfPresent(forKey: .comment)
        summary = try container.decodeXCResultType(forKey: .summary)
    }
}
