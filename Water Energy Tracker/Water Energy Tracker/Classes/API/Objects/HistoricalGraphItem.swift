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
    var C1: Int?
    var C2: Int?
    var C3: Int?
    var C4: Int?
    var C5: Int?
    var C6: Int?
    var C7: Int?
    var C8: Int?

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
