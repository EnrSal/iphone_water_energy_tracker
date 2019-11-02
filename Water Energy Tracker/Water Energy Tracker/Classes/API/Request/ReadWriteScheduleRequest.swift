//
//  ReadWriteScheduleRequest.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/2/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class ReadWriteScheduleRequest: NSObject, Mappable {

    var name: String?
    var Command: String?
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        name <- map["name"]
        Command <- map["Command"]
    }

}
