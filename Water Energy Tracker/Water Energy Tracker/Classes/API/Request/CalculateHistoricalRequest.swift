//
//  CalculateHistoricalRequest.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class CalculateHistoricalRequest: NSObject, Mappable {

    var mac: String?
    var fromdate: String?
    var todate: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        mac <- map["mac"]
        fromdate <- map["fromdate"]
        todate <- map["todate"]
    }

}
