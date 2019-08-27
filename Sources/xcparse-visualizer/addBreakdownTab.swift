//
//  passDataSegue.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/22/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class addBreakdownTab: NSStoryboardSegue {

    override func perform() {
        let sourceVC = self.sourceController as! NSViewController
        let destVC = self.destinationController as! NSViewController
        if sourceVC.parent is NSTabViewController {
            if let tabVC = sourceVC.parent as? NSTabViewController {
                tabVC.addChild(destVC)
                tabVC.selectedTabViewItemIndex = tabVC.tabViewItems.count-1
            }
        }
        else {
            if let tabVC = sourceVC.parent?.parent as? NSTabViewController {
                tabVC.addChild(destVC)
                tabVC.selectedTabViewItemIndex = tabVC.tabViewItems.count-1
            }
        }
    }
}
