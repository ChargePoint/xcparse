//
//  SourceCodeSymbolInfo.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class SourceCodeSymbolInfo : Codable {
    public let imageName: String?
    public let symbolName: String?
    public let location: SourceCodeLocation?

    enum SourceCodeSymbolInfoCodingKeys: String, CodingKey {
        case imageName
        case symbolName
        case location
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SourceCodeSymbolInfoCodingKeys.self)
        imageName = try container.decodeXCResultTypeIfPresent(forKey: .imageName)
        symbolName = try container.decodeXCResultTypeIfPresent(forKey: .symbolName)
        location = try container.decodeXCResultObjectIfPresent(forKey: .location)
    }
}
