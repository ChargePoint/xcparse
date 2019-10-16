//
//  Reference.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class Reference : Codable {
    public let id: String
    public let targetType: TypeDefinition?

    enum ReferenceCodingKeys: String, CodingKey {
        case id
        case targetType
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ReferenceCodingKeys.self)
        id = try container.decodeXCResultType(forKey: .id)
        targetType = try container.decodeXCResultObjectIfPresent(forKey: .targetType)
    }

    public func modelFromReference<T: Codable>(withXCResult xcresult: XCResult) -> T? {
        if self.targetType?.getType() != T.self {
            return nil
        }

        guard let summaryGetResult = XCResultToolCommand.Get(withXCResult: xcresult, id: self.id, outputPath: "", format: .json).run() else {
            return nil
        }

        do {
            let jsonString = try summaryGetResult.utf8Output()
            if summaryGetResult.exitStatus != .terminated(code: 0) || jsonString == "" {
                return nil
            }

            let referenceData = Data(jsonString.utf8)
            return try JSONDecoder().decode(T.self, from: referenceData)
        } catch {
            return nil
        }
    }
}
