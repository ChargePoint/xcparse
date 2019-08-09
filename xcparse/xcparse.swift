//
//  xcparse.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

enum OptionType: String {
    case screenshot = "s"
    case xcov = "x"
    case help = "h"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "s", "screenshots": self = .screenshot
            case "x", "xcov": self = .xcov
            case "h", "help": self = .help
            case "q", "quit": self = .quit
            default: self = .unknown
        }
    }
}

class Xcparse {
    
    let console = Console()

    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }
    
    func extractScreenshots(xcresultPath : String, destination : String) {
        let xcresultJSON : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json")
        //print(xcresultJSON)
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        let json = try! JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as? [String:AnyObject]
        //print(json?["_type"]?["_name"])
        
        let actionRecord: ActionsInvocationRecord = try! CPTJSONAdapter.model(of: ActionsInvocationRecord.self, fromJSONDictionary: json) as! ActionsInvocationRecord
        //print(actionRecord)
        
        var testReferenceIDs: [String] = []
        
        for action in actionRecord.actions {
            if let actionResult = action.actionResult {
                if let testRef = actionResult.testsRef {
                    testReferenceIDs.append(testRef.id)
                }
            }
        }
        
        //print("Test ref IDs: \(testReferenceIDs)")
        
        var summaryRefIDs: [String] = []
        for testRefID in testReferenceIDs {
            let testJSONString : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(testRefID)")
            let testJSON = try! JSONSerialization.jsonObject(with: Data(testJSONString.utf8), options: []) as? [String:AnyObject]
            let testPlanRunSummaries: ActionTestPlanRunSummaries = try! CPTJSONAdapter.model(of: ActionTestPlanRunSummaries.self, fromJSONDictionary: testJSON) as! ActionTestPlanRunSummaries
            //print("Test plan summaries: \(testPlanRunSummaries)")
            for summary in testPlanRunSummaries.summaries {
                let testableSummaries = summary.testableSummaries
                for testableSummary in testableSummaries {
                    let tests = testableSummary.tests
                    for test in tests {
                        let subtests1 = test.subtests
                        for subtest1 in subtests1 {
                            let subtests2 = subtest1.subtests
                            for subtest2 in subtests2 {
                                let subtests3 = subtest2.subtests
                                for subtest3 in subtests3 {
                                    if let summaryRef = subtest3.summaryRef {
                                        summaryRefIDs.append(summaryRef.id)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        //print("Subtest summary ref IDs:\n\(summaryRefIDs)")
        
        var screenshotRefIDs: [String] = []
        var screenshotNames: [String] = []
        for summaryRefID in summaryRefIDs {
            let testJSONString : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(summaryRefID)")
            let testJSON = try! JSONSerialization.jsonObject(with: Data(testJSONString.utf8), options: []) as? [String:AnyObject]
            //let testActivitySummaries = testJSON?["_values"] as! [AnyHashable: Any]
            //print(testJSONString)
            let testSummary : ActionTestSummary = try! CPTJSONAdapter.model(of: ActionTestSummary.self, fromJSONDictionary: testJSON) as! ActionTestSummary
            //print(testSummary)
            for activitySummary in testSummary.activitySummaries {
                let attachments = activitySummary.attachments
                for attachment in attachments {
                    if let payloadRef = attachment.payloadRef {
                        screenshotRefIDs.append(payloadRef.id)
                    }
                    if let filename = attachment.filename {
                        screenshotNames.append(filename)
                    }
                }
            }
        }
        print("Screenshot IDs: \n\(screenshotRefIDs)")
        print("Screenshot Names: \n\(screenshotNames)")
        print("Screenshot IDs count: \(screenshotRefIDs.count)")
        print("Screenshot names count: \(screenshotNames.count)")
        let dir = console.shellCommand("mkdir \(destination)/testScreenshots/")
        if dir != "" {
            print(dir)
        }
        for i in 0...screenshotRefIDs.count-1 {
            let save = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format raw --id \(screenshotRefIDs[i]) > \(destination)/testScreenshots/\(screenshotNames[i])")
            if(save != "") {
                print(save)
            }
        }
        // TODO: Alex - we need to get down to the ID of
        // ActionTestPlanRunSUmmaries.summaries([ActionAbstractTestSummary/ActionTestPlanRunSummary]).testableSummaries([ActionAbstractTestSummary/ActionTestableSummary]).tests([ActionAbstractTestSummary/ActionTestSummaryGroup]).subtests([ActionAbstractTestSummary/ActionTestSummaryGroup]).subtests([ActionTestMetadata]).summaryRef.id
        
        // It's important to note here that in order to do this next parsing, we need to implement the supertypes behind our parsers & start using
        // MTLJSONSerializing protocol's + (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary;
        
    }
    
    func extractCoverage(xcresultPath : String, destination : String) {
        let xcresultJSON : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json")
        //print(xcresultJSON)
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        let json = try! JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as? [String:AnyObject]
        //print(json?["_type"]?["_name"])
        
        let actionRecord: ActionsInvocationRecord = try! CPTJSONAdapter.model(of: ActionsInvocationRecord.self, fromJSONDictionary: json) as! ActionsInvocationRecord
        //print(actionRecord)
        
        var coverageReferenceIDs: [String] = []
        
        for action in actionRecord.actions {
            if let actionResult = action.actionResult {
                if let coverage = actionResult.coverage {
                    if let reportRef = coverage.reportRef {
                        coverageReferenceIDs.append(reportRef.id)
                    }
                }
            }
        }
        for id in coverageReferenceIDs {
            let result = console.shellCommand("xcrun xcresulttool export --path \(xcresultPath) --id \(id) --output-path \(destination)/action.xccovreport --type file")
            print(result)
        }
    }
    
    func staticMode() {
        let argCount = CommandLine.argc
        let argument = CommandLine.arguments[1]
        var startIndex : String.Index
        if argument.count == 2 {
            startIndex = argument.index(argument.startIndex, offsetBy:  1)
        }
        else {
            startIndex = argument.index(argument.startIndex, offsetBy:  2)
        }
        let substr = String(argument[startIndex...])
        let (option, value) = getOption(substr)
        console.writeMessage("Argument count: \(argCount) Option: \(option) value: \(value)")
        switch (option) {
        case .screenshot:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                extractScreenshots(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
        case .xcov:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                extractCoverage(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
            break
        case .help:
            console.printUsage()
        case .unknown, .quit:
            console.writeMessage("Unknown option \(value)")
            console.printUsage()
        }
    }
    
    func interactiveMode() {
        console.writeMessage("Welcome to xcparse. This program can extract screenshots and coverage files from an *.xcresult file.")
        var shouldQuit = false
        while !shouldQuit {
            console.writeMessage("Type 's' to extract screenshots, 'x' to extract code coverage files, 'h' for help, or 'q' to quit.")
            let (option, value) = getOption(console.getInput())
            switch option {
            case .screenshot:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your screenshots:")
                let destinationPath = console.getInput()
                extractScreenshots(xcresultPath: path, destination: destinationPath)
            case .xcov:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your coverage file:")
                let destinationPath = console.getInput()
                extractCoverage(xcresultPath: path, destination: destinationPath)
                break
            case .quit:
                shouldQuit = true
            case .help:
                console.printUsage()
            default:
                console.writeMessage("Unknown option \(value)", to: .error)
                console.printUsage()
            }
        }
    }
    
    
}
