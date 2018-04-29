//
//  GetDataRequest.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class GetDataRequest: NSObject, Mappable {

    var mac: String?
    var utct: String?
    var stype: Int?
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        mac <- map["mac"]
        utct <- map["utct"]
        stype <- map["stype"]        
    }

}
