//
//  NamesResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/25/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class NamesResponse: NSObject, Mappable {

    var DeviceName: String?
    var Name1: String?
    var Name2: String?
    var Name3: String?
    var Name4: String?
    var Name5: String?
    var Name6: String?
    var Name7: String?
    var Name8: String?
    var Stype: String?
    var ShareNumber: String?
    var TempShareNumber: String?
    var Macid: String?
    var retstring: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        DeviceName <- map["DeviceName"]
        Name1 <- map["Name1"]
        Name2 <- map["Name2"]
        Name3 <- map["Name3"]
        Name4 <- map["Name4"]
        Name5 <- map["Name5"]
        Name6 <- map["Name6"]
        Name7 <- map["Name7"]
        Name8 <- map["Name8"]

        Stype <- map["Stype"]
        ShareNumber <- map["ShareNumber"]
        TempShareNumber <- map["TempShareNumber"]
        Macid <- map["Macid"]
        retstring <- map["retstring"]

    }

}

