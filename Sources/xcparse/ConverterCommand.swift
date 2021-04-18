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

enum FileType: String, Codable {
    case appThinReport = "appThinningReport"
}

struct ConverterCommand: Command {
    let command = "convert"
    let overview = "Convert report to JSON format"
    let usage = "convert [OPTIONS] [reportType] [reportDirectory] [outputDirectory]"

    var inputFormat: OptionArgument<String>
    var path: PositionalArgument<PathArgument>
    var resultPath: PositionalArgument<PathArgument>

    init(parser: ArgumentParser) {
        let subparser = parser.add(subparser: command, usage: usage, overview: overview)
        inputFormat = subparser.add(option: "--input-format", kind: String.self,
                                    usage: "Specify your input format")

        path = subparser.add(positional: "outputFile", kind: PathArgument.self,
                             optional: false, usage: "Path to output file", completion: .filename)
        resultPath = subparser.add(positional: "resultDirectory", kind: PathArgument.self,
                                   optional: true, usage: "Result directory to export results to", completion: .filename)

    }

    func run(with arguments: ArgumentParser.Result) throws {
        typealias converter = ReportConverter

        guard let reportPathArgument = arguments.get(path) else {
            print("Missing file path")
            return
        }

        guard let option = arguments.get(inputFormat)
        else {
            print("Missing option")
            return
        }

        guard let type = FileType(rawValue: option)
        else {
            print("Missing type")
            return
        }

        let reportPath = reportPathArgument.path

        guard let outputPath = arguments.get(self.resultPath)?.path  else {
            print("Missing result directory path")
            return
        }

        guard let report = FileController.loadFile(url: reportPath.pathString),
              let urlPath = URL(string: reportPath.pathString)
        else {
            print("File unreadable")
            return
        }

        switch type {
        case .appThinReport:
            let fileName = urlPath.deletingPathExtension().lastPathComponent
            converter.writeJSON(from: report, to: outputPath.pathString, outputName: fileName)
        }
    }
}
