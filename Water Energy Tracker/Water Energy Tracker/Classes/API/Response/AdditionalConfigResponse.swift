//
//  AdditionalConfigResponse.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 12/20/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import ObjectMapper

class AdditionalConfigResponse: NSObject, Mappable {
   
    var UserCFlow: String?
    var UserGPM: String?
    var UserRelay: String?

    override init() {}
    
    // MARK: ServerObject
    
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        UserCFlow <- map["UserCFlow"]
        UserGPM <- map["UserGPM"]
        UserRelay <- map["UserRelay"]
    }

}
