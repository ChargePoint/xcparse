//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation
open class ActivityLogSectionAttachment: Codable {
    public let identifier: String
    public let majorVersion: UInt8
    public let minorVersion: UInt8
    public let data: Data

    enum ActivityLogSectionAttachmentCodingKeys: String, CodingKey {
        case identifier
        case majorVersion
        case minorVersion
        case data
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActivityLogSectionAttachmentCodingKeys.self)
         identifier = try container.decodeXCResultType(forKey: .identifier)
         majorVersion = try container.decodeXCResultType(forKey: .majorVersion)
         minorVersion = try container.decodeXCResultType(forKey: .minorVersion)
         data = try container.decodeXCResultType(forKey: .data)
    }
}
