//
//  XCPParser.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import XCParseCore

enum OptionType: String {
    case screenshot = "s"
    case xcov = "x"
    case help = "h"
    case xcpretty = "p"
    case quit = "q"
    case unknown
  
    init(value: String) {
        switch value {
            case "s", "screenshots": self = .screenshot
            case "x", "xcov": self = .xcov
            case "h", "help": self = .help
            case "p", "xcpretty": self = .xcpretty
            case "q", "quit": self = .quit
            default: self = .unknown
        }
    }
}

class XCPParser {
    
    let console = Console()

    func getOption(_ option: String) -> (option:OptionType, value: String) {
      return (OptionType(value: option), option)
    }
    
    func extractScreenshots(xcresultPath : String, destination : String) throws {
        let xcresultJSON : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json")
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        var json : [String:AnyObject]
        do {
            json = try JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as! [String:AnyObject]
        } catch {
            return
        }
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        var testReferenceIDs: [String] = []
        
        for action in actionRecord.actions {
            if let testRef =  action.actionResult.testsRef {
                testReferenceIDs.append(testRef.id)
            }
        }
        
        
        var summaryRefIDs: [String] = []
        for testRefID in testReferenceIDs {
            let testJSONString : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(testRefID)")
            let testRefData = Data(testJSONString.utf8)
            
            let testJSON = try! JSONSerialization.jsonObject(with: testRefData, options: []) as? [String:AnyObject]
            
            let testPlanRunSummaries = try decoder.decode(ActionTestPlanRunSummaries.self, from: testRefData)
            
            // TODO: Alex - We need to put this loop out of its misery
            for summary in testPlanRunSummaries.summaries {
                let testableSummaries = summary.testableSummaries
                for testableSummary in testableSummaries {
                    let tests = testableSummary.tests
                    for test in tests {
                        if let testSummaryGroup = test as? ActionTestSummaryGroup {
                            let subtests1 = testSummaryGroup.subtests
                            for subtest1 in subtests1 {
                                if let testSummaryGroup2 = subtest1 as? ActionTestSummaryGroup {
                                    let subtests2 = testSummaryGroup2.subtests
                                    for subtest2 in subtests2 {
                                        if let testSummaryGroup3 = subtest2 as? ActionTestSummaryGroup {
                                            let subtests3 = testSummaryGroup3.subtests
                                            for subtest3 in subtests3 {
                                                if let testMetadata = subtest3 as? ActionTestMetadata {
                                                    if let summaryRef = testMetadata.summaryRef {
                                                        summaryRefIDs.append(summaryRef.id)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
        var screenshotRefIDs: [String] = []
        var screenshotNames: [String] = []
        for summaryRefID in summaryRefIDs {
            let testJSONString : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(summaryRefID)")
            let summaryRefData = Data(testJSONString.utf8)
            
//            let testJSON = try! JSONSerialization.jsonObject(with: summaryRefData, options: []) as? [String:AnyObject]
            
            let testSummary = try decoder.decode(ActionTestSummary.self, from: summaryRefData)
            
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
        let dir = console.shellCommand("mkdir \(destination)/testScreenshots/")
        for i in 0...screenshotRefIDs.count-1 {
            let save = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format raw --id \(screenshotRefIDs[i]) > \(destination)/testScreenshots/\(screenshotNames[i])")
        }
        
    }
    
    func extractCoverage(xcresultPath : String, destination : String) throws {
        let xcresultJSON : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json")
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        var json : [String:AnyObject]
        do {
            json = try JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as! [String:AnyObject]
        } catch {
            return
        }
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        var coverageReferenceIDs: [String] = []
        
        for action in actionRecord.actions {
            if let reportRef = action.actionResult.coverage.reportRef {
                coverageReferenceIDs.append(reportRef.id)
            }
        }
        for id in coverageReferenceIDs {
            let result = console.shellCommand("xcrun xcresulttool export --path \(xcresultPath) --id \(id) --output-path \(destination)/action.xccovreport --type file")
        }
    }
    
    func extractLogs(xcresultPath : String, destination : String) throws {
        let xcresultJSON : String = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json")
        let xcresultJSONData = Data(xcresultJSON.utf8)
        
        var json : [String:AnyObject]
        do {
            json = try JSONSerialization.jsonObject(with: xcresultJSONData, options: []) as! [String:AnyObject]
        } catch {
            return
        }
        
        let decoder = JSONDecoder()
        let actionRecord = try decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
        
        var logReferenceIDs: [String] = []
        
        for action in actionRecord.actions {
            if let logRef = action.actionResult.logRef {
                logReferenceIDs.append(logRef.id)
            }
        }
        for id in logReferenceIDs {
            let result = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --id \(id) | XCPRETTY_JSON_FILE_OUTPUT=\(destination)/errors.json xcpretty -f `xcpretty-json-formatter`")
        }
    }
    
    func staticMode() throws {
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
        switch (option) {
        case .screenshot:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                try extractScreenshots(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
        case .xcov:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                try extractCoverage(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
        case .xcpretty:
            if argCount != 4 {
                console.writeMessage("Missing Arguments", to: .error)
                console.printUsage()
            }
            else {
                try extractLogs(xcresultPath: CommandLine.arguments[2], destination: CommandLine.arguments[3])
            }
        case .help:
            console.printUsage()
        case .unknown, .quit:
            console.writeMessage("\nUnknown option \(argument)\n")
            console.printUsage()
        }
    }
    
    func interactiveMode() throws {
        console.writeMessage("Welcome to xcparse. This program can extract screenshots and coverage files from an *.xcresult file.")
        var shouldQuit = false
        while !shouldQuit {
            console.writeMessage("Type 's' to extract screenshots, 'x' to extract code coverage files, 'p' to export *.xcresult logs in xcpretty-json-format, 'h' for help, or 'q' to quit.")
            let (option, value) = getOption(console.getInput())
            switch option {
            case .screenshot:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your screenshots:")
                let destinationPath = console.getInput()
                try extractScreenshots(xcresultPath: path, destination: destinationPath)
            case .xcov:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your coverage file:")
                let destinationPath = console.getInput()
                try extractCoverage(xcresultPath: path, destination: destinationPath)
            case .xcpretty:
                console.writeMessage("Type the path to your *.xcresult file:")
                let path = console.getInput()
                console.writeMessage("Type the path to the destination folder for your coverage file:")
                let destinationPath = console.getInput()
                try extractLogs(xcresultPath: path, destination: destinationPath)
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
