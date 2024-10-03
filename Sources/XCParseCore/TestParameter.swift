//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestParameter: Codable {
    public let label: String
    public let name: String?
    public let typeName: String?
    public let fullyQualifiedTypeName: String?

    enum TestParameterCodingKeys: String, CodingKey {
        case label
        case name
        case typeName
        case fullyQualifiedTypeName
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestParameterCodingKeys.self)
        label = try container.decodeXCResultType(forKey: .label)
        name = try container.decodeXCResultTypeIfPresent(forKey: .name)
        typeName = try container.decodeXCResultTypeIfPresent(forKey: .typeName)
        fullyQualifiedTypeName = try container.decodeXCResultTypeIfPresent(forKey: .fullyQualifiedTypeName)
    }
}
