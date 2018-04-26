//
//  GenericRequest.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/25/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class GenericRequest: NSObject, Mappable {

    var name: String?
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        name <- map["name"]
    }

}
