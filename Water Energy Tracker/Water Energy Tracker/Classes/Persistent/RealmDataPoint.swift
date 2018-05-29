//
//  RealmDataPoint.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import RealmSwift

class RealmDataPoint: Object {

    @objc dynamic var timestamp: Date?
    @objc dynamic var identifier: String?
    @objc dynamic var Temperature: Double = 0
    @objc dynamic var Alarm: String?
    @objc dynamic var Indicator: String?
    @objc dynamic var UTCtime: String?
    @objc dynamic var mac: String?
    @objc dynamic var stype: Int = 0
    @objc dynamic var alias: String?
    @objc dynamic var SignalStrength: Int = 0
    @objc dynamic var SolMinutes: Int = 0
    @objc dynamic var Temp2: Double = 0
    @objc dynamic var HS2: Double = 0
    @objc dynamic var SC2: Double = 0
    @objc dynamic var Daily: Int = 0
    @objc dynamic var Hourly: Int = 0
    
    @objc dynamic var HLON: Int = 0
    @objc dynamic var C1: Int = 0
    @objc dynamic var C2: Int = 0
    @objc dynamic var C3: Int = 0
    @objc dynamic var C4: Int = 0
    @objc dynamic var C5: Int = 0
    @objc dynamic var C6: Int = 0
    @objc dynamic var C7: Int = 0
    @objc dynamic var C8: Int = 0

    
    convenience init(fromDataPoint dataPoint: RemoteDevice) {
        self.init()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!

        if let UTCtime = dataPoint.UTCtime {
            //print("UTCTIME \(UTCtime)")
            self.timestamp = formatter.date(from: UTCtime)
            if self.timestamp == nil {
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                self.timestamp = formatter.date(from: UTCtime)
            }
        }

        mac = dataPoint.mac!;
        identifier = "\(mac!):\(self.timestamp!.timeIntervalSince1970)"
        Temperature = dataPoint.Temperature!
        if let Alarm = dataPoint.Alarm {
            self.Alarm = Alarm
        }
        if let Indicator = dataPoint.Indicator {
            self.Indicator = Indicator
        }

        SignalStrength = Int(dataPoint.SignalStrength!)
        if let SolMinutes = dataPoint.SolMinutes {
            self.SolMinutes = SolMinutes
        }
        
        if let Temp2 = dataPoint.Temp2 {
            self.Temp2 = Temp2
        }
        if let HS2 = dataPoint.HS2 {
            self.HS2 = HS2
        }
        if let SC2 = dataPoint.SC2 {
            self.SC2 = SC2
        }

        if let HLON = dataPoint.HLON {
            self.HLON = HLON
        }

        if let C1 = dataPoint.C1 {
            self.C1 = C1
        }
        if let C2 = dataPoint.C2 {
            self.C2 = C2
        }
        if let C3 = dataPoint.C3 {
            self.C3 = C3
        }
        if let C4 = dataPoint.C4 {
            self.C4 = C4
        }
        if let C5 = dataPoint.C5 {
            self.C5 = C5
        }
        if let C6 = dataPoint.C6 {
            self.C6 = C6
        }
        if let C7 = dataPoint.C7 {
            self.C7 = C7
        }
        if let C8 = dataPoint.C8 {
            self.C8 = C8
        }
        if let Daily = dataPoint.Daily {
            self.Daily = Daily
        }
        if let Hourly = dataPoint.Hourly {
            self.Hourly = Hourly
        }

    }

}
