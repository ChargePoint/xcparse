//
//  File.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/21/20.
//  Copyright © 2020 ChargePoint, Inc. All rights reserved.

import Basic
import Foundation
import SPMUtility

struct FastlaneDeliverCommand: Command {
    let command = "fastlane-deliver"
    let overview = "Extracts screenshots from xcresult and saves it in fastlane directory for delivery."
    let usage = "[OPTIONS] xcresult fastlaneDirectory"

    var path: PositionalArgument<PathArgument>
    var fastlanePath: PositionalArgument<PathArgument>
    var verbose: OptionArgument<Bool>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)
        path = subparser.add(positional: "xcresult", kind: PathArgument.self,
                             optional: false, usage: "Path to the xcresult file", completion: .filename)
        fastlanePath = subparser.add(positional: "fastlaneDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Fastlane directory to export results to", completion: .filename)
        verbose = subparser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Enable verbose logging")

    }

    func run(with arguments: ArgumentParser.Result) throws {
        guard let xcresultPathArgument = arguments.get(path) else {
            print("Missing xcresult path")
            return
        }
        let xcresultPath = xcresultPathArgument.path

        var fastlanePath: AbsolutePath
        if let fastlanePathArgument = arguments.get(self.fastlanePath) {
            fastlanePath = fastlanePathArgument.path
        } else {
            print("Missing fastlane directory path")
            return
        }

        let verbose = arguments.get(self.verbose) ?? false

        let xcpParser = XCPParser()
        xcpParser.console.verbose = verbose
        
        var options = AttachmentExportOptions(fastlaneDeliver: true,
                                              attachmentFilter: {
                                                return UTTypeConformsTo($0.uniformTypeIdentifier as CFString, "public.image" as CFString)})
        
        options.xcresulttoolCompatability = xcpParser.checkXCResultToolCompatability(destination: fastlanePath.pathString)

        try xcpParser.extractAttachments(xcresultPath: xcresultPath.pathString,
                                         destination: fastlanePath.pathString, options: options)
    }
}
