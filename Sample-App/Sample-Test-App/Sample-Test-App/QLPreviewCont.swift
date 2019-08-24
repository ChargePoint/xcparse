//
//  QLPreviewCont.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/21/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa
import Quartz
import QuickLook

class QLPreviewCont: NSResponder, QLPreviewPanelDataSource, QLPreviewPanelDelegate {
    
    var pictures: NSMutableArray
    
    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        return pictures.count
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, previewItemAt index: Int) -> QLPreviewItem! {
        return NSURL(string: pictures.object(at: index) as! String)
    }
    
    override init() {
        pictures = NSMutableArray()
        super.init()
    }
    
    func previewPanel(_ panel: QLPreviewPanel!, handle event: NSEvent!) -> Bool {
        let appController : AppDelegate = NSApplication.shared.delegate as! AppDelegate
        if event.type.rawValue = UInt(NX_KEYDOWN) {
            appController.pictureTable.keyDown(event)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPictures(theArray: NSArray)
    {
        pictures.removeAllObjects()
        pictures.setArray(theArray as! [Any])
    }
}
