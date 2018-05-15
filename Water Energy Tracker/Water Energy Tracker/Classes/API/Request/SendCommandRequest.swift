//
//  SendCommandRequest.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class SendCommandRequest: NSObject, Mappable {
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
