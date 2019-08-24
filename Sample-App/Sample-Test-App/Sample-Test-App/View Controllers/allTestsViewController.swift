//
//  allTestsViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/22/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class allTestsViewController: NSViewController {

    @IBOutlet weak var SampleAppTestContainer: NSView!
    @IBOutlet weak var navToTestsContainer: NSView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        SampleAppTestContainer.isHidden = true
    }
    
}
