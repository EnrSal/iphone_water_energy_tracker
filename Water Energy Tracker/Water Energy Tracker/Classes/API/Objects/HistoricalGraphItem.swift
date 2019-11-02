//
//  HistoricalGraphItem.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/2/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class HistoricalGraphItem: NSObject, Mappable {

    var StorageDate: String?
    var C1: String?
    var C2: String?
    var C3: String?
    var C4: String?
    var C5: String?
    var C6: String?
    var C7: String?
    var C8: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        StorageDate <- map["StorageDate"]
        C1 <- map["C1"]
        C2 <- map["C2"]
        C3 <- map["C3"]
        C4 <- map["C4"]
        C5 <- map["C5"]
        C6 <- map["C6"]
        C7 <- map["C7"]
        C8 <- map["C8"]
    }

}
