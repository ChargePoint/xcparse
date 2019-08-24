//
//  testTabViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class testTabViewController: NSViewController {

    @IBOutlet weak var testButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.identifier = NSUserInterfaceItemIdentifier(rawValue: "testButton")
        // Do view setup here.
    }
    
}
