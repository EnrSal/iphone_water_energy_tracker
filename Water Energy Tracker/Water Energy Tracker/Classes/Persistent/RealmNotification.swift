//
//  RealmNotification.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import RealmSwift

class RealmNotification: Object {
    
    @objc dynamic var time: Date?
    @objc dynamic var text: String?
    @objc dynamic var mac_address: String?


    convenience init(fromNotification notification: RemoteNotification, mac:String) {
        self.init()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!
        
        if let UTCtime = notification.MyUTCtime {
            self.time = formatter.date(from: UTCtime)
        }
        
        mac_address = mac

        if let Notif = notification.Notif {
            self.text = Notif
        }
        
    }
}
