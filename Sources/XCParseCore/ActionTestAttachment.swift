//
//  ActionTestAttachment.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

public enum ActionTestAttachmentLifetime : String {
    case keepAlways
    case deleteOnSuccess
}

open class ActionTestAttachment : Codable {
    public let uniformTypeIdentifier: String // Note: You'll want to use CoreServices' UTType functions with this
    public let name: String?
    public let timestamp: Date?
    public let userInfo: SortedKeyValueArray?
    public let lifetime: String
    public let inActivityIdentifier: Int
    public let filename: String?
    public let payloadRef: Reference?
    public let payloadSize: Int

    // xcresult 3.34 and above
    public let uuid: String?

    enum ActionTestAttachmentCodingKeys: String, CodingKey {
        case uniformTypeIdentifier
        case name
        case uuid
        case timestamp
        case userInfo
        case lifetime
        case inActivityIdentifier
        case filename
        case payloadRef
        case payloadSize
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestAttachmentCodingKeys.self)
        uniformTypeIdentifier = try container.decodeXCResultType(forKey: .uniformTypeIdentifier)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
        uuid = try container.decodeXCResultTypeIfPresent(forKey: .uuid)
        timestamp = try container.decodeXCResultTypeIfPresent(forKey: .timestamp)
        userInfo = try container.decodeXCResultObjectIfPresent(forKey: .userInfo)
        lifetime = try container.decodeXCResultType(forKey: .lifetime)
        inActivityIdentifier = try container.decodeXCResultType(forKey: .inActivityIdentifier)
        filename = try container.decodeXCResultTypeIfPresent(forKey: .filename)
        payloadRef = try container.decodeXCResultObjectIfPresent(forKey: .payloadRef)
        payloadSize = try container.decodeXCResultType(forKey: .payloadSize)
    }
}
