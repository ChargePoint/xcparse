//
//  ActionRecord.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionRecord : Codable {
    public let schemeCommandName: String
    public let schemeTaskName: String
    public let title: String?
    public let startedTime: Date
    public let endedTime: Date
    public let runDestination: ActionRunDestinationRecord
    public let buildResult: ActionResult
    public let actionResult: ActionResult
    
    // xcresult 3.39 and above
    public let testPlanName: String?

    enum ActionRecordCodingKeys: String, CodingKey {
        case schemeCommandName
        case schemeTaskName
        case title
        case startedTime
        case endedTime
        case runDestination
        case buildResult
        case actionResult
        case testPlanName
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionRecordCodingKeys.self)
        schemeCommandName = try container.decodeXCResultType(forKey: .schemeCommandName)
        schemeTaskName = try container.decodeXCResultType(forKey: .schemeTaskName)
        title = try container.decodeXCResultTypeIfPresent(forKey: .title)
        startedTime = try container.decodeXCResultType(forKey: .startedTime)
        endedTime = try container.decodeXCResultType(forKey: .endedTime)
        runDestination = try container.decodeXCResultObject(forKey: .runDestination)
        buildResult = try container.decodeXCResultObject(forKey: .buildResult)
        actionResult = try container.decodeXCResultObject(forKey: .actionResult)
        testPlanName = try container.decodeXCResultTypeIfPresent(forKey: .testPlanName)
    }
}
