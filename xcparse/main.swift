//
//  main.swift
//  xcparse
//
//  Created by Alexander Botkin on 7/30/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import Mantle


// MARK: -
// MARK: Shell

// user3064009's answer on https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
func shell(_ command: String) -> String {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
    
    return output
}

// MARK: -
// MARK: Main

print("Hello, World!")

let xcresultJSON : String = shell("xcrun xcresulttool get --path ~/Downloads/Test2.xcresult --format json")
print(xcresultJSON)
let xcresultJSONData = Data(xcresultJSON.utf8)

let json = try JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as? [String:AnyObject]
print(json?["_type"]?["_name"])

let actionRecord: ActionsInvocationRecord = try CPTJSONAdapter.model(of: ActionsInvocationRecord.self, fromJSONDictionary: json) as! ActionsInvocationRecord
print(actionRecord)

var testReferenceIDs: [String] = []

for action in actionRecord.actions {
    if let actionResult = action.actionResult {
        if let testRef = actionResult.testsRef {
            testReferenceIDs.append(testRef.id)
        }
    }
}

print("Test ref IDs: \(testReferenceIDs)")

for testRefID in testReferenceIDs {
    let testJSONString : String = shell("xcrun xcresulttool get --path ~/Downloads/Test2.xcresult --format json --id \(testRefID)")
    let testJSON = try JSONSerialization.jsonObject(with: Data(testJSONString.utf8), options: []) as? [String:AnyObject]
    
    let testPlanRunSummaries: ActionTestPlanRunSummaries = try CPTJSONAdapter.model(of: ActionTestPlanRunSummaries.self, fromJSONDictionary: testJSON) as! ActionTestPlanRunSummaries
    print("Test plan summaries: \(testPlanRunSummaries)")
    
    // TODO: Alex - we need to get down to the ID of
    // ActionTestPlanRunSUmmaries.summaries([ActionAbstractTestSummary/ActionTestPlanRunSummary]).testableSummaries([ActionAbstractTestSummary/ActionTestableSummary]).tests([ActionAbstractTestSummary/ActionTestSummaryGroup]).subtests([ActionAbstractTestSummary/ActionTestSummaryGroup]).subtests([ActionTestMetadata]).summaryRef.id
    
    // It's important to note here that in order to do this next parsing, we need to implement the supertypes behind our parsers & start using
    // MTLJSONSerializing protocol's + (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary;
}
