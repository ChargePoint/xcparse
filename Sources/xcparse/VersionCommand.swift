//
//  VersionCommand.swift
//  xcparse
//
//  Created by Alexander Botkin on 10/12/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Basic
import Foundation
import SPMUtility
import XCParseCore

struct VersionCommand: Command {
    let command = "version"
    let overview = "Prints version of xcparse"
    let usage = ""

    init(parser: ArgumentParser) {
        _ = parser.add(subparser: command, usage: usage, overview: overview)
    }

    func run(with arguments: ArgumentParser.Result) throws {
        let xcpParser = XCPParser()
        xcpParser.printVersion()
    }
}
