//
//  RemoteDevice.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class RemoteDevice: NSObject, Mappable {

    var Temperature: Double?
    var Alarm: String?
    var Indicator: String?
    var UTCtime: String?
    var mac: String?
    var stype: Int?
    var alias: String?
    var SignalStrength: Int?
    var SolMinutes: Int?
    var Temp2: Double?
    var HS2: Double?
    var SC2: Double?
    var Daily: Int?
    var Hourly: Int?
    
    var HLON: Int?
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
        Temperature <- map["Temperature"]
        Alarm <- map["Alarm"]
        Indicator <- map["Indicator"]
        UTCtime <- map["UTCtime"]
        mac <- map["mac"]
        stype <- map["stype"]
        alias <- map["alias"]
        SignalStrength <- map["SignalStrength"]
        SolMinutes <- map["SolMinutes"]
        
        Temp2 <- map["Temp2"]
        HS2 <- map["HS2"]
        SC2 <- map["SC2"]
        Daily <- map["Daily"]
        Hourly <- map["Hourly"]
        
        HLON <- map["HLON"]
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
