//
//  RealmModels.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 14/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import Foundation
import RealmSwift

class URLsAccessed : Object {
    dynamic var url = ""
    dynamic var lastAccess = NSDate()
    dynamic var totalSeconds: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "url"
    }
}

class UserSessions : Object {
    
    dynamic var host = ""
    dynamic var lastAccess = NSDate()
    dynamic var totalSeconds: Double = 0.0
    let urls = List<URLsAccessed>()
    
    override static func primaryKey() -> String? {
        return "host"
    }
}
