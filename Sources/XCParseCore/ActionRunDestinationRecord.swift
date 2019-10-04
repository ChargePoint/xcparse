//
//  ActionRunDestinationRecord.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionRunDestinationRecord : Codable {
    public let displayName: String
    public let targetArchitecture: String
    public let targetDeviceRecord: ActionDeviceRecord
    public let localComputerRecord: ActionDeviceRecord
    public let targetSDKRecord: ActionSDKRecord

    enum ActionRunDestinationRecordCodingKeys: String, CodingKey {
        case displayName
        case targetArchitecture
        case targetDeviceRecord
        case localComputerRecord
        case targetSDKRecord
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRunDestinationRecordCodingKeys.self)
        displayName = try container.decodeXCResultType(forKey: .displayName)
        targetArchitecture = try container.decodeXCResultType(forKey: .targetArchitecture)
        targetDeviceRecord = try container.decodeXCResultObject(forKey: .targetDeviceRecord)
        localComputerRecord = try container.decodeXCResultObject(forKey: .localComputerRecord)
        targetSDKRecord = try container.decodeXCResultObject(forKey: .targetSDKRecord)
    }
}
