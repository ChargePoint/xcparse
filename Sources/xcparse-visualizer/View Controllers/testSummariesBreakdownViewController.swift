//
//  testSummariesBreakdownViewController.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/20/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import XCParseCore

class testSummariesBreakdownViewController: NSViewController {
    @IBOutlet weak var testSummariesOutlineView: NSOutlineView!
    var testSummariesObjects = [XCResultObject]()
    var xcresultJSONData = Data()
    var xcresultPath : String = ""
    var destinationPath : String = ""
    var temporaryDirectoryURL : URL = URL(string: ".")!
    @IBAction func doubleClickedItem(_ sender: NSOutlineView) {
        if let item = sender.item(atRow: sender.clickedRow) as? XCResultNestedObjectType {
            if item.name == "id" {
                if let parentItem = sender.parent(forItem: item) as? XCResultNestedObjectType {
                    if parentItem.name == "summaryRef" {
                        if(!xcresultPath.isEmpty) {
                            let console = Console()
                            let xcresultJSON = console.shellCommand("xcrun xcresulttool get --path \(xcresultPath) --format json --id \(item.value)")
                            xcresultJSONData = Data(xcresultJSON.utf8)
                            saveData()
                            self.performSegue(withIdentifier: "addSummaryBreakdownTab", sender: sender)
                        }
                    }
                }
            }
        }
    }
    
    func saveData() {
        xcparseFields.xcresultJSONData = xcresultJSONData
        xcparseFields.xcresultPath = xcresultPath
        xcparseFields.destinationPath = destinationPath
        xcparseFields.temporaryDirectoryURL = temporaryDirectoryURL
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
        let test = try! decoder.decode(ActionTestPlanRunSummaries.self, from: xcresultJSONData)
        test.generateObjectTree()
        testSummariesObjects.append(test)
        testSummariesOutlineView.dataSource = self
        testSummariesOutlineView.delegate = self
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}

extension testSummariesBreakdownViewController: NSOutlineViewDataSource {
    
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
                return testSummariesObjects.count
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
                return testSummariesObjects[index]
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

extension testSummariesBreakdownViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
                    textField.stringValue = xcObject.value
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
