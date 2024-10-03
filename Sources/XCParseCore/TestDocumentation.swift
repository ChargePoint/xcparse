//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation

open class TestDocumentation: Codable {
    public let content: String
    public let format: String

    enum TestDocumentationCodingKeys: String, CodingKey {
        case content
        case format
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestDocumentationCodingKeys.self)
        content = try container.decodeXCResultType(forKey: .content)
        format = try container.decodeXCResultType(forKey: .format)
    }
}
