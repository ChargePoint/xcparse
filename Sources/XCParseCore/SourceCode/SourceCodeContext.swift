//
//  SourceCodeContext.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class SourceCodeContext : Codable {
    public let location: SourceCodeLocation?
    public let callStack: [SourceCodeFrame]

    enum SourceCodeContextCodingKeys: String, CodingKey {
        case location
        case callStack
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SourceCodeContextCodingKeys.self)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
        callStack = try container.decodeXCResultArray(forKey: .callStack)
    }
}
