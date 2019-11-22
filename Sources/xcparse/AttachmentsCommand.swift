//
//  AttachmentsCommand.swift
//  xcparse
//
//  Created by Alex Botkin on 10/16/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility

struct AttachmentsCommand: Command {
    let command = "attachments"
    let overview = "Extracts attachments from xcresult and saves it in output folder."
    let usage = "[OPTIONS] xcresult [outputDirectory]"

    var path: PositionalArgument<PathArgument>
    var outputPath: PositionalArgument<PathArgument>
    var verbose: OptionArgument<Bool>

    var divideByModel: OptionArgument<Bool>
    var divideByOS: OptionArgument<Bool>
    var divideByTestRun: OptionArgument<Bool>
    var divideByTestPlanConfig: OptionArgument<Bool>
    var divideByLanguage: OptionArgument<Bool>
    var divideByRegion: OptionArgument<Bool>
    var divideByTest: OptionArgument<Bool>

    var utiWhitelist: OptionArgument<[String]>
    var activityTypeWhitelist: OptionArgument<[String]>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)
        path = subparser.add(positional: "xcresult", kind: PathArgument.self,
                             optional: false, usage: "Path to the xcresult file", completion: .filename)
        outputPath = subparser.add(positional: "outputDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Folder to export results to", completion: .filename)
        verbose = subparser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Enable verbose logging")

        divideByModel = subparser.add(option: "--model", shortName: nil, kind: Bool.self, usage: "Divide attachments by model")
        divideByOS = subparser.add(option: "--os", shortName: nil, kind: Bool.self, usage: "Divide attachments by OS")
        divideByTestRun = subparser.add(option: "--test-run", shortName: nil, kind: Bool.self, usage: "Deprecated. Use --test-plan-config")
        divideByTestPlanConfig = subparser.add(option: "--test-plan-config", shortName: nil, kind: Bool.self, usage: "Divide attachments by test plan configuration")
        divideByLanguage = subparser.add(option: "--language", shortName: nil, kind: Bool.self, usage: "Divide attachments by test language")
        divideByRegion = subparser.add(option: "--region", shortName: nil, kind: Bool.self, usage: "Divide attachments by test region")
        divideByTest = subparser.add(option: "--test", shortName: nil, kind: Bool.self, usage: "Divide attachments by test")

        utiWhitelist = subparser.add(option: "--uti", shortName: nil, kind: [String].self, strategy: .upToNextOption,
                                     usage: "Whitelist of uniform type identifiers (UTI) attachments must conform to [optional, example: \"--uti public.image public.plain-text\"]")
        activityTypeWhitelist = subparser.add(option: "--activity-type", shortName: nil, kind: [String].self, strategy: .upToNextOption,
                                              usage: "Whitelist of acceptable activity types for attachments. If value does not specify domain, \"com.apple.dt.xctest.activity-type.\" is assumed and prefixed to the value [optional, example: \"--activity-type userCreated attachmentContainer com.apple.dt.xctest.activity-type.testAssertionFailure\"]")
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
        var options = AttachmentExportOptions(addTestScreenshotsDirectory: false,
                                              divideByTargetModel: arguments.get(self.divideByModel) ?? false,
                                              divideByTargetOS: arguments.get(self.divideByOS) ?? false,
                                              divideByTestPlanConfig: arguments.get(self.divideByTestPlanConfig) ?? (arguments.get(self.divideByTestRun) ?? false),
                                              divideByLanguage: arguments.get(self.divideByLanguage) ?? false,
                                              divideByRegion: arguments.get(self.divideByRegion) ?? false,
                                              divideByTest: arguments.get(self.divideByTest) ?? false)
        if let allowedUTIsToExport = arguments.get(self.utiWhitelist) {
            options.attachmentFilter = {
                let attachmentUTI = $0.uniformTypeIdentifier as CFString
                for allowedUTI in allowedUTIsToExport {
                    if UTTypeConformsTo(attachmentUTI, allowedUTI as CFString) {
                        return true
                    }
                }
                return false
            }
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

        // Now let's get extracting
        try xcpParser.extractAttachments(xcresultPath: xcresultPath.pathString,
                                         destination: outputPath.pathString,
                                         options: options)
    }
}
