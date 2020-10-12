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
    var SatelliteFrom: Int?
    var BaseStationNameId: Int?
    var UTCtime: String?
    var DataType: String?
    var header = false

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        DataValue <- map["DataValue"]
        SatelliteFrom <- map["SatelliteFrom"]
        BaseStationNameId <- map["BaseStationNameId"]
        UTCtime <- map["UTCtime"]
        DataType <- map["DataType"]
   }
}
