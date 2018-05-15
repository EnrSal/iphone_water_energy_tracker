//
//  Notification.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class RemoteNotification: NSObject, Mappable {

    var Notif: String?
    var MyUTCtime: String?
    
    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        Notif <- map["Notif"]
        MyUTCtime <- map["MyUTCtime"]
    }

}
