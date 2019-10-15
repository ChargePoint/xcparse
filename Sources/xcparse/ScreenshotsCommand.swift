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

        let options = AttachmentExportOptions(addTestScreenshotsDirectory: arguments.get(self.addTestScreenshotDirectory) ?? false,
                                              divideByTargetModel: arguments.get(self.divideByModel) ?? false,
                                              divideByTargetOS: arguments.get(self.divideByOS) ?? false)
        try xcpParser.extractScreenshots(xcresultPath: xcresultPath.pathString,
                                         destination: outputPath.pathString,
                                         options: options)
    }
}
