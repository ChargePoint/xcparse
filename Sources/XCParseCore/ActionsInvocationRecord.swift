//
//  ActionsInvocationRecord.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

public class ActionsInvocationRecord : Codable {
    public let metadataRef: Reference?
    public let metrics: ResultMetrics
    public let issues: ResultIssueSummaries
    public let actions: [ActionRecord]
    public let archive: ArchiveInfo?

    enum ActionsInvocationRecordCodingKeys: String, CodingKey {
        case metadataRef
        case metrics
        case issues
        case actions
        case archive
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionsInvocationRecordCodingKeys.self)
        metadataRef = try container.decodeXCResultObjectIfPresent(forKey: .metadataRef)
        metrics = try container.decodeXCResultObject(forKey: .metrics)
        issues = try container.decodeXCResultObject(forKey: .issues)

        actions = try container.decodeXCResultArray(forKey: .actions)

        archive = try container.decodeXCResultObjectIfPresent(forKey: .archive)
    }

    class public func recordFromXCResult(_ xcresult: XCResult) -> ActionsInvocationRecord? {
        guard let xcresultGetResult = XCResultToolCommand.Get(withXCResult: xcresult, id: "", outputPath: "", format: .json).run() else {
            return nil
        }

        do {
            let xcresultJSON = try xcresultGetResult.utf8Output()
            if xcresultGetResult.exitStatus != .terminated(code: 0) || xcresultJSON == "" {
                return nil
            }

            let xcresultJSONData = Data(xcresultJSON.utf8)
            return try JSONDecoder().decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        } catch {
            return nil
        }
    }
}
