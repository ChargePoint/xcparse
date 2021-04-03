//
//  File.swift
//  
//
//  Created by Vido Shaweddy on 3/30/21.
//

import Foundation

import Basic
import Converter
import Foundation
import SPMUtility

struct ConverterCommand: Command {
    let command = "convert"
    let overview = "Convert app thinning report to JSON format"
    let usage = "[OPTIONS] xcresult convert"

    var path: PositionalArgument<PathArgument>
    var resultPath: PositionalArgument<PathArgument>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)
        path = subparser.add(positional: "appThinningReport", kind: PathArgument.self,
                             optional: false, usage: "Path to the report file", completion: .filename)
        resultPath = subparser.add(positional: "resultDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Result directory to export results to", completion: .filename)

    }

    func run(with arguments: ArgumentParser.Result) throws {
        typealias converter = ReportConverter

        guard let reportPathArgument = arguments.get(path) else {
            print("Missing file path")
            return
        }
        let reportPath = reportPathArgument.path

        var outputPath: AbsolutePath
        if let resultPathArgument = arguments.get(self.resultPath) {
            outputPath = resultPathArgument.path
        } else {
            print("Missing result directory path")
            return
        }

        guard let report = FileController.loadFile(url: reportPath.pathString) else {
            print("File unreadable")
            return
        }

        converter.writeJSON(from: report, to: outputPath.pathString)
    }
}
