//
//  firstViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/13/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class firstViewController: NSViewController {

    
    @IBOutlet weak var messageField: NSTextField!
    @IBOutlet weak var container: NSView!
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var updateButton: NSButton!
    var message = ""
    var label = ""
    @IBAction func isButtonClick(_ sender: Any) {
        message = messageField?.stringValue ?? ""
        if message.isEmpty {
            return
        }
        else {
            label = message
            titleLabel.stringValue = label
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
