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
                    let latest = realm.objects(RealmNotification.self).filter("mac_address = '\(self.savior.savior_address!)'").sorted(byKeyPath: "time", ascending: false).first
                  
                    
                    if (latest != nil) {
                        print("latest -->\(latest) num hours \(abs(latest!.time!.timeIntervalSinceNow)))")
                    }
                    
                    if (latest != nil) && (abs(latest!.time!.timeIntervalSinceNow) <= 1*60*60 ) {
                        self.name.textColor = UIColor(red: 0, green: 0.3882, blue: 0.0549, alpha: 1.0)
                        self.num.textColor = UIColor(red: 0, green: 0.3882, blue: 0.0549, alpha: 1.0)
                    } else {
                        self.name.textColor = UIColor.black
                        self.num.textColor = UIColor.black
                    }
                    
                }
            }
        }
    }
    
}
extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
}
