//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestValue : Codable {
    public let description: String
    public let debugDescription: String?
    public let typeName: String?
    public let fullyQualifiedTypeName: String?
    public let label: String?
    public let isCollection: Bool
    public let children: TestValue?

    enum TestValueCodingKeys: String, CodingKey {
        case description
        case debugDescription
        case typeName
        case fullyQualifiedTypeName
        case label
        case isCollection
        case children
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestValueCodingKeys.self)
        description = try container.decodeXCResultType(forKey: .description)
        debugDescription = try container.decodeXCResultTypeIfPresent(forKey: .debugDescription)
        typeName = try container.decodeXCResultTypeIfPresent(forKey: .typeName)
        fullyQualifiedTypeName = try container.decodeXCResultTypeIfPresent(forKey: .fullyQualifiedTypeName)
        label = try container.decodeXCResultTypeIfPresent(forKey: .label)
        isCollection = try container.decodeXCResultType(forKey: .isCollection)
        children = try container.decodeXCResultTypeIfPresent(forKey: .children)
    }
}
