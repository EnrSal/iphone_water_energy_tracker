//
//  DataPersistenceManager.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/28/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DataPersistenceManager: NSObject {

    static let shared: DataPersistenceManager = DataPersistenceManager()

    
    func getData(date:Date) {
        let realm = try! Realm()
        let saviors = realm.objects(RealmSavior.self)

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMddyyyyHH:mm:ss"

        let datestr = formatter.string(from: date)
        
        for savior in saviors {
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceUpdatingEvent"),
                                            object: nil,
                                            userInfo: ["object":savior.savior_address!])
            let req:GetDataRequest = GetDataRequest()
            req.mac = savior.savior_address!
            req.stype = savior.stype
            req.utct = datestr
            
            AzureApi.shared.getData(req: req, completionHandler: { (error:ServerError?, response:GetDataResponse?) in
                
            })

        }
        
    }
}
