//
//  Command.swift
//  xcparse
//
//  Created by Alexander Botkin on 10/12/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import TSCUtility

// This is cribbed form a great blog post on ArgumentParser
// https://www.enekoalonso.com/articles/handling-commands-with-swift-package-manager
protocol Command {
    var command: String { get }
    var overview: String { get }
    var usage: String { get }

    init(parser: ArgumentParser)
    func run(with arguments: ArgumentParser.Result) throws
}
