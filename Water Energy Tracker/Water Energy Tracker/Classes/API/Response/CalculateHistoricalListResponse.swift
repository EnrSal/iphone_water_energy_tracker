//
//  CalculateHistoricalListResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/2/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class CalculateHistoricalListResponse: NSObject, Mappable {

    var AllKWH:[HistoricalGraphItem] = []
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        AllKWH <- map["AllKWH"]
    }

}
