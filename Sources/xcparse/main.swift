//
//  main.swift
//  xcparse
//
//  Created by Alexander Botkin on 7/30/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation


// MARK: -
// MARK: Main

let parser = XCPParser()
if CommandLine.argc < 2 {
    try parser.interactiveMode()
} else {
    try parser.staticMode()
}

