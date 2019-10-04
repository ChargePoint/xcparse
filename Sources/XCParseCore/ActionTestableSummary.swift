//
//  ActionTestableSummary.swift
//  XCParseCore
//
//  Created by Alex Botkin on 10/4/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

open class ActionTestableSummary : ActionAbstractTestSummary {
    public let projectRelativePath: String?
    public let targetName: String?
    public let testKind: String?
    public let tests: [ActionTestSummaryIdentifiableObject]
    public let diagnosticsDirectoryName: String?
    public let failureSummaries: [ActionTestFailureSummary]
    public let testLanguage: String?
    public let testRegion: String?

    enum ActionTestableSummaryCodingKeys: String, CodingKey {
        case projectRelativePath
        case targetName
        case testKind
        case tests
        case diagnosticsDirectoryName
        case failureSummaries
        case testLanguage
        case testRegion
    }

     required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ActionTestableSummaryCodingKeys.self)
        projectRelativePath = try container.decodeXCResultTypeIfPresent(forKey: .projectRelativePath)
        targetName = try container.decodeXCResultTypeIfPresent(forKey: .targetName)
        testKind = try container.decodeXCResultTypeIfPresent(forKey: .testKind)

        tests = try container.decodeIfPresent(XCResultArrayValue<ActionTestSummaryIdentifiableObject>.self, forKey: .tests)?.values ?? []

        diagnosticsDirectoryName = try container.decodeXCResultTypeIfPresent(forKey: .diagnosticsDirectoryName)

        failureSummaries = try container.decodeIfPresent(XCResultArrayValue<ActionTestFailureSummary>.self, forKey: .failureSummaries)?.values ?? []

        testLanguage = try container.decodeXCResultTypeIfPresent(forKey: .testLanguage)
        testRegion = try container.decodeXCResultTypeIfPresent(forKey: .testRegion)

        try super.init(from: decoder)
    }
}
