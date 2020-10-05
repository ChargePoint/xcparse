//
//  TestAssociatedError.swift
//  
//
//  Created by Alexander Botkin on 10/4/20.
//

import Foundation

open class TestAssociatedError : Codable {
    public let domain: String?
    public let code: Int?
    public let userInfo: SortedKeyValueArray?

    enum TestAssociatedErrorCodingKeys: String, CodingKey {
        case domain
        case code
        case userInfo
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TestAssociatedErrorCodingKeys.self)
        domain = try container.decodeXCResultTypeIfPresent(forKey: .domain)
        code = try container.decodeXCResultTypeIfPresent(forKey: .code)
        userInfo = try container.decodeXCResultObjectIfPresent(forKey: .userInfo)
    }
}
