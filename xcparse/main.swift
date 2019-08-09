//
//  main.swift
//  xcparse
//
//  Created by Alexander Botkin on 7/30/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation
import Mantle


// MARK: -
// MARK: Main

let xcparse = Xcparse()
if CommandLine.argc < 2 {
    xcparse.interactiveMode()
} else {
    xcparse.staticMode()
}

