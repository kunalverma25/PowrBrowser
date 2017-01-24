//
//  RealmModels.swift
//  PowrBrowser
//
//  Created by Kunal Verma on 14/01/17.
//  Copyright © 2017 Kunal Verma. All rights reserved.
//

import Foundation
import RealmSwift

class SavedInfo : Object {
    dynamic var UserAccount = ""
    dynamic var Url = ""
    dynamic var Host = ""
    dynamic var VisitTime = ""
    dynamic var Transition = ""
    dynamic var LifeTime: Double = 0.0
    dynamic var LocalTime = ""
    dynamic var referrer = ""
    dynamic var tabId = ""
    
    override static func primaryKey() -> String? {
        return "Url"
    }
}

class Bookmark : Object {
    dynamic var UserID = ""
    dynamic var Name = ""
    dynamic var Url = ""
    
    override static func primaryKey() -> String? {
        return "Url"
    }
}

//class URLsAccessed : Object {
//    dynamic var url = ""
//    dynamic var lastAccess = ""
//    dynamic var totalSeconds: Double = 0.0
//    
//    override static func primaryKey() -> String? {
//        return "url"
//    }
//}
//
//class UserSessions : Object {
//    
//    dynamic var host = ""
//    dynamic var lastAccess = ""
//    dynamic var totalSeconds: Double = 0.0
//    let urls = List<URLsAccessed>()
//    
//    override static func primaryKey() -> String? {
//        return "host"
//    }
//}
//
//[19/01/17, 11:36:40 PM] Keshav Malani: {
//    "UserAccount" : "XXXX",
//    "Url" : "https://www.facebook.com/",
//    "Host" : "facebook.com",
//    "VisitTime" : ISODate("2016-12-15T00:29:08.115+0000"),
//    "Transition" : "link",
//    "LifeTime" : 3260.0,
//    "LocalTime" : ISODate("2016-12-15T00:29:08.115+0000"),
//    "referrer" : "https://www.facebook.com/euan.mccutcheon",
//    "tabId" : "252",
//}
