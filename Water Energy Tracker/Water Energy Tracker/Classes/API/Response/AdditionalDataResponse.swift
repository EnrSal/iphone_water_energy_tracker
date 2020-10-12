//
//  AdditionalDataResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 10/11/20.
//  Copyright © 2020 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class AdditionalDataResponse: NSObject, Mappable {
    var items:[AdditionalDataItem] = []
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        items <- map["items"]
    }
}
