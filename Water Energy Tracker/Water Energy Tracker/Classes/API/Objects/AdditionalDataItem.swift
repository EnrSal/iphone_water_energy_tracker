//
//  AdditionalDataItem.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 10/11/20.
//  Copyright © 2020 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class AdditionalDataItem: NSObject, Mappable {

    var DataValue: Double?
    var SatelliteFromName: String?
    var DeviceName: String?
    var UTCtime: String?
    var DataType: String?
    var header = false

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        DataValue <- map["DataValue"]
        SatelliteFromName <- map["SatelliteFromName"]
        DeviceName <- map["DeviceName"]
        UTCtime <- map["UTCtime"]
        DataType <- map["DataType"]
   }
}
