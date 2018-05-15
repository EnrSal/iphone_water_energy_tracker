//
//  GenericResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class GenericResponse: NSObject, Mappable {
    var returnstring: String?
    var retstring: String?
    var ReturnCode: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        returnstring <- map["returnstring"]
        retstring <- map["retstring"]
        ReturnCode <- map["ReturnCode"]
    }
}
