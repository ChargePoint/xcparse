//
//  ActivityLogAnalyzerWarningMessage.swift
//  XCParseCore
//
//  Created by Alexander Botkin on 10/9/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActivityLogAnalyzerWarningMessage : ActivityLogMessage {

     required public init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
