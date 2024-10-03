//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestExpression : Codable {
    public let sourceCode: String
    public let value: TestValue?
    public let subexpressions: [TestExpression]

    enum TestExpressionCodingKeys: String, CodingKey {
        case sourceCode
        case value
        case subexpressions
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestExpressionCodingKeys.self)
        sourceCode = try container.decodeXCResultType(forKey: .sourceCode)
        value = try container.decodeXCResultType(forKey: .value)
        subexpressions = try container.decodeXCResultArray(forKey: .subexpressions)
    }
}
