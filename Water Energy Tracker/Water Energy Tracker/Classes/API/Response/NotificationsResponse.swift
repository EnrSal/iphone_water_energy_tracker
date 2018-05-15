//
//  NotificationsResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class NotificationsResponse: NSObject, Mappable {
    var Count: Int?
    var Result: [RemoteNotification] = []
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        Count <- map["Count"]
        Result <- map["Result"]
    }

}
