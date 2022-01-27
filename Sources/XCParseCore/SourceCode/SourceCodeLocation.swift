//
//  SourceCodeLocation.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class SourceCodeLocation : Codable {
    public let filePath: String?
    public let lineNumber: Int?

    enum SourceCodeLocationCodingKeys: String, CodingKey {
        case filePath
        case lineNumber
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SourceCodeLocationCodingKeys.self)
        filePath = try container.decodeXCResultTypeIfPresent(forKey: .filePath)
        lineNumber = try container.decodeXCResultTypeIfPresent(forKey: .lineNumber)
    }
}
