//
//  customSegue.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/22/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class customSegue: NSStoryboardSegue {
    
    override func perform() {
        if let sourceVC  = self.sourceController as? testTabViewController {
            let destVC = self.destinationController as! NSViewController
            let containerVC = sourceVC.parent as! allTestsViewController
            containerVC.navToTestsContainer.isHidden = true
            containerVC.SampleAppTestContainer.isHidden = false
        }
        else if let sourceVC = self.sourceController as? firstViewController {
            let destVC = self.destinationController as! NSViewController
            let containerVC = sourceVC.parent as! allTestsViewController
            containerVC.navToTestsContainer.isHidden = false
            containerVC.SampleAppTestContainer.isHidden = true
        }
        
    }
}
