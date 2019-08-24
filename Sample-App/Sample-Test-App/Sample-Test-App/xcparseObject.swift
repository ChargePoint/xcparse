//
//  xcparseModels.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class xcparseObject: NSObject {
    let name: String
    var children = [xcparseObjectValue]()
    init(name: String) {
      self.name = name
    }
    class func ObjectList(_ fileName: String) -> [xcparseObject] {
     //1
     var xcparseObjects = [xcparseObject]()
       
     //2
     if let ObjectList = NSArray(contentsOfFile: fileName) as? [NSDictionary] {
       //3
       for ObjectValues in ObjectList {
         //4
         let xcObject = xcparseObject(name: ObjectValues.object(forKey: "Tests") as! String)
         //5
         let items = ObjectValues.object(forKey: "TestArray") as! [NSDictionary]
         //6
         for dict in items {
           //7
           let item = xcparseObjectValue(dictionary: dict)
           xcObject.children.append(item)
         }
         //8
         xcparseObjects.append(xcObject)
       }
     }
     //9
     return xcparseObjects
    }
}
