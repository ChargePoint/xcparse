//
//  xcparseObjectBreakdown.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import xcparser

class objectBreakdownViewController: NSViewController {
    @IBOutlet weak var objectBreakdownOutlineView: NSOutlineView!
    var xcparseObjects = [XCResultObject]()
    var xcresultJSONData = Data()
    var xcresultPath : String = ""
    var destinationPath : String = ""
    var temporaryDirectoryURL : URL = URL(string: ".")!
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        if let item = sender.item(atRow: sender.clickedRow) as? XCResultNestedObjectType {
            if item.name == "id" {
                if let parentItem = sender.parent(forItem: item) as? XCResultNestedObjectType {
                    if parentItem.name == "testsRef" {
                        if(!xcresultPath.isEmpty) {
                            let console = Console()
                            let xcresultJSON = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(item.value)")
                            xcresultJSONData = Data(xcresultJSON.utf8)
                            saveData()
                            self.performSegue(withIdentifier: "addTestBreakdownTab", sender: sender)
                        }
                    }
                    else if parentItem.name == "reportRef" {
                        if(!xcresultPath.isEmpty) {
                            let console = Console()
                            let _ = console.shellCommand("xcrun xcresulttool export --path \(xcresultPath) --id \(item.value) --output-path \(temporaryDirectoryURL.path)/action.xccovreport --type file")
                            performSegue(withIdentifier: "objectBreakdownExport", sender: sender)
                        }
                    }
                }
            }
        }
    }
    
    func copyFileAndOpen() {
        grabGlobalData()
        let console = Console()
        let _ = console.shellCommand("cp \(temporaryDirectoryURL.path)/action.xccovreport \(destinationPath)/action.xccovreport")
        let _ = console.shellCommand("open \(destinationPath)/action.xccovreport")
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let vc = segue.destinationController as? exportViewController {
            vc.sourceVC = self
        }
    }
    
    func saveData() {
        xcparseFields.xcresultJSONData = xcresultJSONData
        xcparseFields.xcresultPath = xcresultPath
        xcparseFields.destinationPath = destinationPath
        xcparseFields.temporaryDirectoryURL = temporaryDirectoryURL
    }
    
    
    func grabGlobalData() {
        xcresultJSONData = xcparseFields.xcresultJSONData
        xcresultPath = xcparseFields.xcresultPath
        destinationPath = xcparseFields.destinationPath
        temporaryDirectoryURL = xcparseFields.temporaryDirectoryURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        grabGlobalData()
        if !xcresultJSONData.isEmpty {
            let testJSON = try! JSONSerialization.jsonObject(with: Data(xcresultJSONData), options: []) as? [String:AnyObject]
            let decoder = JSONDecoder()
            let test = try! decoder.decode(ActionsInvocationRecord.self, from: xcresultJSONData)
            xcparseObjects.append(test)
            test.generateObjectTree()
            objectBreakdownOutlineView.delegate = self
            objectBreakdownOutlineView.dataSource = self
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
}

extension objectBreakdownViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
            if let xcObject = item as? XCResultObject {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectFirstNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectSecondNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectThirdNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectFourthNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectFifthNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectSixthNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectSeventhNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectEighthNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectNinthNesting {
                return xcObject.children.count
            }
            else if let xcObject = item as? XCResultObjectTenthNesting {
                return xcObject.children.count
            }
            else {
                return xcparseObjects.count
            }
         
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
            if let xcObject = item as? XCResultObject {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectFirstNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectSecondNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectThirdNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectFourthNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectFifthNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectSixthNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectSeventhNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectEighthNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectNinthNesting {
                return xcObject.children[index]
            }
            else if let xcObject = item as? XCResultObjectTenthNesting {
                return xcObject.children[index]
            }
            else {
                return xcparseObjects[index]
            }
        
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let xcObject = item as? XCResultObject {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectFirstNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectSecondNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectThirdNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectFourthNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectFifthNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectSixthNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectSeventhNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectEighthNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectNinthNesting {
            return xcObject.children.count > 0
        }
        else if let xcObject = item as? XCResultObjectTenthNesting {
            return xcObject.children.count > 0
        }
        return false
    }
}

extension objectBreakdownViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        var value : String = ""
        if let xcObject = item as? XCResultNestedObjectType {
            if xcObject.name == "coverage" {
                for file in xcObject.children {
                    if file.name == "reportRef" {
                        if file.children.count > 0 {
                            value = "Has coverage data"
                        }
                        else {
                            value = "No coverage data"
                        }
                    }
                }
            }
            else if xcObject.name == "actionResult" {
                for file in xcObject.children {
                    if file.name == "testsRef" {
                        if file.children.count > 0 {
                            value = "Has tests"
                        }
                        else {
                            value = "No tests"
                        }
                    }
                }
            }
            else {
                value = xcObject.value
            }
        }
        if let xcObject = item as? XCResultObject {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ObjectCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.type.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectFirstNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectSecondNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SecondObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectThirdNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ThirdObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectFourthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FourthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectFifthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FifthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectSixthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SixthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectSeventhNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SeventhObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectEighthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EighthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectNinthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "NinthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectTenthNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TenthObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        else if let xcObject = item as? XCResultObjectEleventhNesting {
            if tableColumn!.identifier.rawValue == "ValueColumn" {
            //2
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ValueCell"), owner: self) as? NSTableCellView
                
                if let textField = view?.textField {
              //3
                    textField.stringValue = value
                    textField.sizeToFit()
                }
            }
            else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EleventhObjectValueCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
              //5
                    textField.stringValue = xcObject.name
                    textField.sizeToFit()
                }
                // More code here
            }
        }
        return view
    }
    
}

