//
//  ScreenshotsCommand.swift
//  xcparse
//
//  Created by Alexander Botkin on 10/12/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility

struct ScreenshotsCommand: Command {
    let command = "screenshots"
    let overview = "Extracts screenshots from xcresult and saves it in output folder."
    let usage = "[OPTIONS] xcresult [outputDirectory]"

    var path: PositionalArgument<PathArgument>
    var outputPath: PositionalArgument<PathArgument>
    var verbose: OptionArgument<Bool>

    var addTestScreenshotDirectory: OptionArgument<Bool>
    var divideByModel: OptionArgument<Bool>
    var divideByOS: OptionArgument<Bool>
    var divideByTestRun: OptionArgument<Bool>
    var divideByTestPlanConfig: OptionArgument<Bool>
    var divideByLanguage: OptionArgument<Bool>
    var divideByRegion: OptionArgument<Bool>
    var divideByTest: OptionArgument<Bool>

    var testStatusWhitelist: OptionArgument<[String]>
    var activityTypeWhitelist: OptionArgument<[String]>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)
        path = subparser.add(positional: "xcresult", kind: PathArgument.self,
                             optional: false, usage: "Path to the xcresult file", completion: .filename)
        outputPath = subparser.add(positional: "outputDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Folder to export results to", completion: .filename)
        verbose = subparser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Enable verbose logging")

        addTestScreenshotDirectory = subparser.add(option: "--legacy", shortName: nil, kind: Bool.self, usage: "Create \"testScreenshots\" directory in outputDirectory & put screenshots in there")
        divideByModel = subparser.add(option: "--model", shortName: nil, kind: Bool.self, usage: "Divide screenshots by model")
        divideByOS = subparser.add(option: "--os", shortName: nil, kind: Bool.self, usage: "Divide screenshots by OS")
        divideByTestRun = subparser.add(option: "--test-run", shortName: nil, kind: Bool.self, usage: "Deprecated. Use --test-plan-config")
        divideByTestPlanConfig = subparser.add(option: "--test-plan-config", shortName: nil, kind: Bool.self, usage: "Divide attachments by test plan configuration")
        divideByLanguage = subparser.add(option: "--language", shortName: nil, kind: Bool.self, usage: "Divide attachments by test language")
        divideByRegion = subparser.add(option: "--region", shortName: nil, kind: Bool.self, usage: "Divide attachments by test region")
        divideByTest = subparser.add(option: "--test", shortName: nil, kind: Bool.self, usage: "Divide screenshots by test")

        testStatusWhitelist = subparser.add(option: "--test-status", shortName: nil, kind: [String].self, strategy: .upToNextOption,
                                            usage: "Whitelist of acceptable test statuses for screenshots [optional, example: \"--test-status Success Failure\"]")
        activityTypeWhitelist = subparser.add(option: "--activity-type", shortName: nil, kind: [String].self, strategy: .upToNextOption,
                                              usage: "Whitelist of acceptable activity types for screenshots. If value does not specify domain, \"com.apple.dt.xctest.activity-type.\" is assumed and prefixed to the value [optional, example: \"--activity-type userCreated attachmentContainer com.apple.dt.xctest.activity-type.testAssertionFailure\"]")
    }

    func run(with arguments: ArgumentParser.Result) throws {
        guard let xcresultPathArgument = arguments.get(path) else {
            print("Missing xcresult path")
            return
        }
        let xcresultPath = xcresultPathArgument.path

        var outputPath: AbsolutePath
        if let outputPathArgument = arguments.get(self.outputPath) {
            outputPath = outputPathArgument.path
        } else if let workingDirectory = localFileSystem.currentWorkingDirectory {
            outputPath = workingDirectory
        } else {
            print("Missing output path")
            return
        }

        let verbose = arguments.get(self.verbose) ?? false

        let xcpParser = XCPParser()
        xcpParser.console.verbose = verbose

        if let _ = arguments.get(self.divideByTestRun) {
            xcpParser.console.writeMessage("\nThe \"--test-run\" flag is deprecated & will be removed in a future release. Please replace with \"--test-plan-config\"\n")
        }

        // Let's set up our export options
        var options = AttachmentExportOptions(addTestScreenshotsDirectory: arguments.get(self.addTestScreenshotDirectory) ?? false,
                                              divideByTargetModel: arguments.get(self.divideByModel) ?? false,
                                              divideByTargetOS: arguments.get(self.divideByOS) ?? false,
                                              divideByTestPlanConfig: arguments.get(self.divideByTestPlanConfig) ?? (arguments.get(self.divideByTestRun) ?? false),
                                              divideByLanguage: arguments.get(self.divideByLanguage) ?? false,
                                              divideByRegion: arguments.get(self.divideByRegion) ?? false,
                                              divideByTest: arguments.get(self.divideByTest) ?? false,
                                              attachmentFilter: {
                                                return UTTypeConformsTo($0.uniformTypeIdentifier as CFString, "public.image" as CFString)
        })
        if let allowedTestStatuses = arguments.get(self.testStatusWhitelist) {
            options.testSummaryFilter = { allowedTestStatuses.contains($0.testStatus) }
        }
        if let allowedActivityTypes = arguments.get(self.activityTypeWhitelist) {
            // Writing the full domain can be exhausting, so if there is no domain specified, assume it was the normal activity type domain
            var additionalActivityTypes: [String] = allowedActivityTypes

            let activityTypesWithoutDomain = allowedActivityTypes.filter { $0.contains(Character(".")) == false }
            for activityType in activityTypesWithoutDomain {
                additionalActivityTypes.append("com.apple.dt.xctest.activity-type." + activityType)
            }

            options.activitySummaryFilter = { additionalActivityTypes.contains($0.activityType) }
        }

        options.xcresulttoolCompatability = xcpParser.checkXCResultToolCompatability(destination: outputPath.pathString)

        try xcpParser.extractAttachments(xcresultPath: xcresultPath.pathString,
                                         destination: outputPath.pathString,
                                         options: options)
    }
}
