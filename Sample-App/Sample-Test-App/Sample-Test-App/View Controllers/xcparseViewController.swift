//
//  xcparseViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import xcparser
class xcparseViewController: NSViewController {

   
    @IBOutlet weak var errorField: NSTextField!
    @IBOutlet var xcPathField: xcparseView!
    @IBOutlet weak var parseButton: NSButton!
    var xcresultJSONData = Data()
    var temporaryDirectoryURL : URL = URL(string: ".")!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func parsePressed(_ sender: Any) {
        let path = xcPathField.string
        if(!path.isEmpty) {
            errorField.isHidden = true
            let console = Console()
            let fileManager: FileManager = FileManager.default
            temporaryDirectoryURL = try! fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: URL(string: "."), create: true)
            let xcresultJSON = console.shellCommand("xcrun xcresulttool get --path \(path) --format json")
            xcresultJSONData = Data(xcresultJSON.utf8)
            saveData()
            self.performSegue(withIdentifier: "objectBreakdown", sender: sender)
        }
        else {
            errorField.isHidden = false
        }
    }
    
    func saveData() {
        xcparseFields.xcresultJSONData = xcresultJSONData
        xcparseFields.xcresultPath = xcPathField.string
        xcparseFields.temporaryDirectoryURL = temporaryDirectoryURL
    }
}
