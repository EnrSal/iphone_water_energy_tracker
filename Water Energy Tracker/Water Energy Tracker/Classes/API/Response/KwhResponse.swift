//
//  KwhResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/9/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class KwhResponse: NSObject, Mappable {
    var Daily: String?
    var Weekly: String?
    var Monthly: String?
    var Yearly: String?

    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        Daily <- map["Daily"]
        Weekly <- map["Weekly"]
        Monthly <- map["Monthly"]
        Yearly <- map["Yearly"]
    }
}

