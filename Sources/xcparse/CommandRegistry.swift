//
//  CommandRegistry.swift
//  xcparse
//
//  Created by Alexander Botkin on 10/12/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility

// This is cribbed form a great blog post on ArgumentParser
// https://www.enekoalonso.com/articles/handling-commands-with-swift-package-manager
struct CommandRegistry {
    private let parser: ArgumentParser
    private var commands: [Command] = []

    init(usage: String, overview: String) {
        parser = ArgumentParser(usage: usage, overview: overview)
    }

    mutating func register(command: Command.Type) {
        commands.append(command.init(parser: parser))
    }

    func run() {
        do {
            let parsedArguments = try parse()
            try process(arguments: parsedArguments)
        }
        catch let error as ArgumentParserError {
            print(error.description)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    private func parse() throws -> ArgumentParser.Result {
        let arguments = Array(CommandLine.arguments.dropFirst())
        return try parser.parse(arguments)
    }

    private func process(arguments: ArgumentParser.Result) throws {
        guard let subparser = arguments.subparser(parser),
            let command = commands.first(where: { $0.command == subparser }) else {
            parser.printUsage(on: stdoutStream)
            return
        }
        try command.run(with: arguments)
    }

}
