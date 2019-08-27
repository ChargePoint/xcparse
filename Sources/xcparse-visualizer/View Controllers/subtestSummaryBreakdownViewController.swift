//
//  subtestSummaryBreakdownViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/20/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import XCParseCore

class subtestSummaryBreakdownViewController: NSViewController {
    
    @IBOutlet weak var subtestSummaryOutlineView: NSOutlineView!
    var subtestSummaryObjects = [XCResultObject]()
    var xcresultJSONData = Data()
    var xcresultPath : String = ""
    var destinationPath : String = ""
    var temporaryDirectoryURL : URL = URL(string: ".")!
    var filename : String = ""
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        if let item = sender.item(atRow: sender.clickedRow) as? XCResultNestedObjectType {
            if item.name == "id" {
                if let parentItem = sender.parent(forItem: item) as? XCResultNestedObjectType {
                    if parentItem.name == "payloadRef" {
                        if let grandParentItem = sender.parent(forItem: parentItem) as? XCResultNestedObjectType {
                            for object in grandParentItem.children {
                                if object.name == "filename" {
                                    filename = object.value
                                    break
                                }
                            }
                            if(!xcresultPath.isEmpty) {
                                let console = Console()
                                console.shellCommand("xcrun xcresulttool export --path \(xcresultPath) --id \(item.value) --output-path \(temporaryDirectoryURL.path)/\(filename) --type file")
                                performSegue(withIdentifier: "subtestSummaryBreakdownExport", sender: sender)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func copyFileAndOpen() {
        grabGlobalData()
        let console = Console()
        console.shellCommand("cp \(temporaryDirectoryURL.path)/\(filename) \(destinationPath)/")
        console.shellCommand("rm \(temporaryDirectoryURL.path)/\(filename)")
        console.shellCommand("open \(destinationPath)/\(filename)")
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let vc = segue.destinationController as? exportViewController {
            vc.sourceVC = self
        }
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
        xcresultJSONData = xcparseFields.xcresultJSONData
        xcresultPath = xcparseFields.xcresultPath
        destinationPath = xcparseFields.destinationPath
        temporaryDirectoryURL = xcparseFields.temporaryDirectoryURL
        let testJSON = try! JSONSerialization.jsonObject(with: Data(xcresultJSONData), options: []) as? [String:AnyObject]
        let decoder = JSONDecoder()
        let test = try! decoder.decode(ActionTestSummary.self, from: xcresultJSONData)
        test.generateObjectTree()
        subtestSummaryObjects.append(test)
        subtestSummaryOutlineView.dataSource = self
        subtestSummaryOutlineView.delegate = self
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}

extension subtestSummaryBreakdownViewController: NSOutlineViewDataSource {
    
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
            return subtestSummaryObjects.count
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
            return subtestSummaryObjects[index]
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

extension subtestSummaryBreakdownViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        var value: String = ""
        if let xcObject = item as? XCResultNestedObjectType {
            if xcObject.name == "ActionTestActivitySummary" {
                for file in xcObject.children {
                    if file.name == "attachments" {
                        if file.children.count > 0 {
                            value = "Has attachment"
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
