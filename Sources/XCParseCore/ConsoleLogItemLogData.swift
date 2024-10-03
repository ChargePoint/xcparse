//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 10/3/24.
//

import Foundation
open class ConsoleLogItemLogData: Codable {
    public let message: String?
    public let subsystem: String?
    public let category: String?
    public let library: String?
    public let format: String?
    public let backtrace: String?
    public let pid: Int32
    public let processName: String?
    public let sessionUUID: String?
    public let tid: UInt64
    public let messageType: UInt8
    public let senderImagePath: String?
    public let senderImageUUID: String?
    public let senderImageOffset: UInt64
    public let unixTimeInterval: Double
    public let timeZone: String?

    enum ConsoleLogItemLogDataCodingKeys: String, CodingKey {
        case message
        case subsystem
        case category
        case library
        case format
        case backtrace
        case pid
        case processName
        case sessionUUID
        case tid
        case messageType
        case senderImagePath
        case senderImageUUID
        case senderImageOffset
        case unixTimeInterval
        case timeZone
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConsoleLogItemLogDataCodingKeys.self)
         message = try container.decodeXCResultTypeIfPresent(forKey: .message)
         subsystem = try container.decodeXCResultTypeIfPresent(forKey: .subsystem)
         category = try container.decodeXCResultTypeIfPresent(forKey: .category)
         library = try container.decodeXCResultTypeIfPresent(forKey: .library)
         format = try container.decodeXCResultTypeIfPresent(forKey: .format)
         backtrace = try container.decodeXCResultTypeIfPresent(forKey: .backtrace)
         pid = try container.decodeXCResultType(forKey: .pid)
         processName = try container.decodeXCResultTypeIfPresent(forKey: .processName)
         sessionUUID = try container.decodeXCResultTypeIfPresent(forKey: .sessionUUID)
         tid = try container.decodeXCResultType(forKey: .tid)
         messageType = try container.decodeXCResultType(forKey: .messageType)
         senderImagePath = try container.decodeXCResultTypeIfPresent(forKey: .senderImagePath)
         senderImageUUID = try container.decodeXCResultTypeIfPresent(forKey: .senderImageUUID)
         senderImageOffset = try container.decodeXCResultType(forKey: .senderImageOffset)
         unixTimeInterval = try container.decodeXCResultType(forKey: .unixTimeInterval)
         timeZone = try container.decodeXCResultTypeIfPresent(forKey: .timeZone)
    }
}
