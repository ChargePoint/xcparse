//
//  exportViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/22/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import xcparser

class exportViewController: NSViewController {

    @IBOutlet weak var folderPathField: NSTextField!
    @IBOutlet weak var selectButton: NSButton!
    @IBOutlet weak var exportButton: NSButton!
    @IBOutlet weak var filenameField: NSTextField!
    @IBOutlet weak var extensionField: NSTextField!
    @IBOutlet weak var enterFilenameLabel: NSTextField!
    var sourceVC : Any!
    var fromToolbar : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func hitEnter(_ sender: NSTextField) {
        if filenameField.isHidden == false {
            if !filenameField.stringValue.isEmpty {
                exportButton.isEnabled = true
            }
        }
    }
    
    @IBAction func clickedSelectButton(_ sender: NSButton) {
        let dialog = NSOpenPanel();
        
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        dialog.canChooseFiles          = false

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result!.path
                folderPathField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        if fromToolbar {
            filenameField.isHidden = false
            extensionField.isHidden = false
            enterFilenameLabel.isHidden = false
            extensionField.placeholderString = ".json"
        }
        if  !folderPathField.stringValue.isEmpty {
                exportButton.isHidden = false
            if filenameField.isHidden == false && filenameField.stringValue.isEmpty {
                exportButton.isEnabled = false
            }
        }
    }
    
    @IBAction func clickExport(_ sender: NSButton) {
        if let vc = sourceVC as? objectBreakdownViewController {
            xcparseFields.destinationPath = folderPathField.stringValue
            vc.copyFileAndOpen()
            dismiss(self)
        }
        else if let vc = sourceVC as? subtestSummaryBreakdownViewController {
            xcparseFields.destinationPath = folderPathField.stringValue
            vc.copyFileAndOpen()
            dismiss(self)
        }
        else {
            if(fromToolbar) {
                fromToolbar = false
                xcparseFields.destinationPath = folderPathField.stringValue
                
                let console = Console()
                if let tabVC = sourceVC as? NSTabViewController {
                    if let vc = tabVC.tabViewItems[tabVC.selectedTabViewItemIndex].viewController as? objectBreakdownViewController {
                        FileManager.default.createFile(atPath: "\(xcparseFields.destinationPath)/\(filenameField.stringValue)\( extensionField.placeholderString!)", contents: vc.xcresultJSONData, attributes: nil)
                    }
                    else if let vc = tabVC.tabViewItems[tabVC.selectedTabViewItemIndex].viewController as? testSummariesBreakdownViewController {
                        FileManager.default.createFile(atPath: "\(xcparseFields.destinationPath)/\(filenameField.stringValue)\( extensionField.placeholderString!)", contents: vc.xcresultJSONData, attributes: nil)
                    }
                    else if let vc = tabVC.tabViewItems[tabVC.selectedTabViewItemIndex].viewController as? subtestSummaryBreakdownViewController {
                        FileManager.default.createFile(atPath: "\(xcparseFields.destinationPath)/\(filenameField.stringValue)\( extensionField.placeholderString!)", contents: vc.xcresultJSONData, attributes: nil)
                    }
                }
                let _ = console.shellCommand("open \(xcparseFields.destinationPath)/\(filenameField.stringValue)\(extensionField.placeholderString!)")
                dismiss(self)
            }
        }
    }
}
