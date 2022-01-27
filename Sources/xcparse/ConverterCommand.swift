//
//  File.swift
//  
//
//  Created by Vido Shaweddy on 3/30/21.
//

import Foundation
import TSCBasic
import TSCUtility
import Converter

struct ConverterCommand: Command {
    let command = "convert"
    let overview = "Converts App Thinning Size Report to JSON and saves it in output folder."
    let usage = "[OPTIONS] appSizeReport [outputDirectory]"

    var flagVariants: OptionArgument<String>
    var reportPath: PositionalArgument<PathArgument>
    var resultPath: PositionalArgument<PathArgument>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)

        flagVariants = subparser.add(option: "--flag-variants", kind: String.self, usage: "Flag variants above the specified size limit [optional, example: \"--flag-variants 10MB\"]")
        reportPath = subparser.add(positional: "appSizeReport", kind: PathArgument.self,
                             optional: false, usage: "Path to App Thinning Size Report", completion: .filename)
        resultPath = subparser.add(positional: "outputDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Folder to export results to", completion: .filename)

    }

    func run(with arguments: ArgumentParser.Result) throws {
        let xcpParser = XCPParser()
        
        var options = ReportConverterOptions()
        if arguments.exists(arg: "--flag-variants") {
            options.flagVariants = FlagVariants(flag: true, limit: arguments.get(flagVariants) ?? "")
        } else {
            options.flagVariants = FlagVariants(flag: false)
        }
        
        guard let reportPathArgument = arguments.get(reportPath) else {
            print("Missing App Thinning Size Report file path")
            return
        }

        let reportPath = reportPathArgument.path

        guard let outputPath = arguments.get(self.resultPath)?.path  else {
            print("Missing output directory path")
            return
        }
        
        try xcpParser.convertAppSizeReport(reportPath: reportPath.pathString, destination: outputPath.pathString, options: options)
    }
}
