//
//  RealmDataPoint.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import RealmSwift

class RealmDataPoint: Object {

    @objc dynamic var Temperature: Double = 0
    @objc dynamic var Alarm: String?
    @objc dynamic var Indicator: String?
    @objc dynamic var UTCtime: String?
    @objc dynamic var mac: String?
    @objc dynamic var stype: Int = 0
    @objc dynamic var alias: String?
    @objc dynamic var SignalStrength: String?
    @objc dynamic var SolMinutes: String?
    @objc dynamic var Temp2: String?
    @objc dynamic var HS2: String?
    @objc dynamic var SC2: String?
    @objc dynamic var Daily: String?
    @objc dynamic var Hourly: String?
    
    @objc dynamic var HLON: String?
    @objc dynamic var C1: String?
    @objc dynamic var C2: String?
    @objc dynamic var C3: String?
    @objc dynamic var C4: String?
    @objc dynamic var C5: String?
    @objc dynamic var C6: String?
    @objc dynamic var C7: String?
    @objc dynamic var C8: String?

}
