//
//  breakdownWIndowController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/23/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class breakdownWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        let destVC = segue.destinationController as! exportViewController
        let windowVC = segue.sourceController as! breakdownWindowController
        if let sourceVC = windowVC.contentViewController {
            destVC.sourceVC = sourceVC
            destVC.fromToolbar = true
        }
    }
}
