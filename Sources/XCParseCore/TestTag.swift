//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestTag: Codable {
    public let identifier: String
    public let name: String
    public let anchors: [String]

    enum TestTagCodingKeys: String, CodingKey {
        case identifier
        case name
        case anchors
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestTagCodingKeys.self)
        identifier = try container.decodeXCResultType(forKey: .identifier)
        name = try container.decodeXCResultType(forKey: .name)
        anchors = try container.decodeXCResultArray(forKey: .anchors)
    }
}
