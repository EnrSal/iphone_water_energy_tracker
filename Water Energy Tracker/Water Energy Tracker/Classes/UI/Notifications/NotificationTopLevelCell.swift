//
//  NotificationTopLevelCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationTopLevelCell: UITableViewCell {

    var savior: RealmSavior!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var num: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate() {
        
        self.name.text = savior.alias!
        self.num.text = "0"
        
        let calendar = NSCalendar.autoupdatingCurrent
        let date = calendar.date(byAdding:.day, value: -1, to: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone!

        let request:NotificationsRequest = NotificationsRequest()
        request.mac = savior.savior_address!
        request.xdate = formatter.string(from: date!)
        
        self.spinner.startAnimating()
        AzureApi.shared.getNotifications(req: request) { (error:ServerError?, response:NotificationsResponse?) in
            if let error = error {
                print(error.getMessage()!)
            } else {
                if let response = response {

                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.num.text = "\(response.Count!)"
                    }

                    let realm = try! Realm()
                    let items = realm.objects(RealmNotification.self).filter("mac_address = '\(self.savior.savior_address!)'").sorted(byKeyPath: "time", ascending: false)
                    try! realm.write {
                        realm.delete(items)
                    
                        for notification in response.Result {
                            let realmNotification = RealmNotification(fromNotification: notification, mac: self.savior.savior_address!)
                            realm.add(realmNotification)
                        }
                    }
                }
            }
        }
    }
    
}
