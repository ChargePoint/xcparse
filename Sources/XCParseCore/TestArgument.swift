//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestArgument: Codable {
    public let parameter: TestParameter?
    public let identifier: String?
    public let description: String
    public let debugDescription: String?
    public let typeName: String?
    public let value: TestValue

    enum TestArgumentCodingKeys: String, CodingKey {
        case parameter
        case identifier
        case description
        case debugDescription
        case typeName
        case value
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestArgumentCodingKeys.self)
        parameter = try container.decodeXCResultTypeIfPresent(forKey: .parameter)
        identifier = try container.decodeXCResultTypeIfPresent(forKey: .identifier)
        description = try container.decodeXCResultType(forKey: .description)
        debugDescription = try container.decodeXCResultTypeIfPresent(forKey: .debugDescription)
        typeName = try container.decodeXCResultTypeIfPresent(forKey: .typeName)
        value = try container.decodeXCResultType(forKey: .value)
    }
}
