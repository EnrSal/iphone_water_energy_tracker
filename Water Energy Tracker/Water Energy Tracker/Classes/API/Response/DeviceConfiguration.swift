//
//  DeviceConfiguration.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class DeviceConfiguration: NSObject, Mappable {

    var name: String?
    var WaterFlowing: String?
    var DetectionsHour: String?
    var DetectionsDay: String?
    var TempLow: String?
    var TempHigh: String?
    var UserTempCalib: String?
    var Hour: String?
    var Day: String?
    var Week: String?
    var Month: String?
    var TimeZone: String?
    var EnergyUnit: String?
    var EnergyUnitPerPulse: String?
    var Unit: String?
    var UnitPerPulse: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        name <- map["name"]
        WaterFlowing <- map["WaterFlowing"]
        DetectionsHour <- map["DetectionsHour"]
        DetectionsDay <- map["DetectionsDay"]
        TempLow <- map["TempLow"]
        TempHigh <- map["TempHigh"]
        UserTempCalib <- map["UserTempCalib"]
        Hour <- map["Hour"]
        Day <- map["Day"]
        Week <- map["Week"]
        Month <- map["Month"]
        TimeZone <- map["TimeZone"]
        EnergyUnit <- map["EnergyUnit"]
        EnergyUnitPerPulse <- map["EnergyUnitPerPulse"]
        Unit <- map["Unit"]
        UnitPerPulse <- map["UnitPerPulse"]

    }

}
