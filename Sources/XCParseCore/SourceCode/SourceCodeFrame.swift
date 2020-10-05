//
//  SourceCodeFrame.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class SourceCodeFrame : Codable {
    public let addressString: String?
    public let symbolInfo: SourceCodeSymbolInfo?

    enum SourceCodeFrameCodingKeys: String, CodingKey {
        case addressString
        case symbolInfo
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SourceCodeFrameCodingKeys.self)
        addressString = try container.decodeXCResultTypeIfPresent(forKey: .addressString)
        symbolInfo = try container.decodeXCResultObjectIfPresent(forKey: .symbolInfo)
    }
}
