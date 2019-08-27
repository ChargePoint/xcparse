//
//  secondViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/13/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class secondViewController: NSViewController {
    
    
    @IBOutlet weak var countLabel: NSTextField!
    var count : String = ""
    @IBAction func buttonPressed(_ sender: Any) {
        if count == "" {
            count = "1"
        }
        else {
            count = String((Int(count) ?? 0) + 1)
        }
        countLabel?.stringValue = count
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        }

    override var representedObject: Any? {
        didSet {
            }
        }
    
}

