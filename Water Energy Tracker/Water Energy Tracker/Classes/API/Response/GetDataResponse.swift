//
//  GetDataResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class GetDataResponse: NSObject, Mappable {

    var LatestUTCT: String?
    var TotalCount: Int?
    var Result: [RemoteDevice] = []
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        LatestUTCT <- map["LatestUTCT"]
        TotalCount <- map["TotalCount"]
        Result <- map["Result"]
    }

}
