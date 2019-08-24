//
//  xcparseObjectValue.swift
//  Sample-Test-App
//
//  Created by Rishab Sukumar on 8/14/19.
//  Copyright © 2019 Rishab Sukumar. All rights reserved.
//

import Cocoa

class xcparseObjectValue: NSObject {
    let title : String
        
    init(dictionary: NSDictionary) {
        self.title = dictionary.object(forKey: "title") as! String
    }
}
