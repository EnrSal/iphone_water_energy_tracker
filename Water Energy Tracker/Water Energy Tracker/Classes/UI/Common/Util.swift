//
//  Util.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/9/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import Foundation
class Util: NSObject {
    
    static func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    static func celsiusToFahrenheit(celsius:Double ) -> Double {
        return (9.0 / 5) * celsius + 32;
    }

    static func pulsesToReadable(pulses:Int, savior:RealmSavior) -> String {
        let kw = Double(pulses)*savior.EnergyUnitPerPulse
        if (kw > 1000) {
            return "\(String(format: "%.2f", kw * 0.001)) MWh"
        }
        return "\(String(format: "%.2f", kw)) kWh"
    }
    
    static func totalpulsesToReadable(pulses:Int, savior:RealmSavior) -> String {
        let kw = Double(pulses)*0.01
        if (kw > 1000) {
            return "\(String(format: "%.2f", kw * 0.001)) MWh"
        }
        return "\(String(format: "%.2f", kw)) kWh"
    }

    static func totalpulsesToReadableThreeDec(pulses:Int, savior:RealmSavior) -> String {
        let kw = Double(pulses)*0.01
        if (kw > 1000) {
            return "\(String(format: "%.3f", kw * 0.001)) MWh"
        }
        return "\(String(format: "%.3f", kw)) kWh"
    }

    static func kwToReadable(kw:Double, savior:RealmSavior) -> String {
        if (kw > 1000) {
            return "\(String(format: "%.2f", kw * 0.001)) MWh"
        }
        return "\(String(format: "%.2f", kw)) kWh"
    }
    
    static func waterPulsesToReadable(pulses:Int, savior:RealmSavior) -> String {
        let kw = Double(pulses)*savior.EnergyUnitPerPulse
        if (kw > 1000) {
            return "\(String(format: "%.2f", kw * 0.001)) kGal"
        }
        return "\(String(format: "%.2f", kw)) Gal"
    }
    
    static func waterPulsesToReadableThreeDec(pulses:Int, savior:RealmSavior) -> String {
        let kw = Double(pulses)*savior.EnergyUnitPerPulse
        if (kw > 1000) {
            return "\(String(format: "%.3f", kw * 0.001)) kGal"
        }
        return "\(String(format: "%.3f", kw)) Gal"
    }

    static func galToReadable(gal:Double, savior:RealmSavior) -> String {
        if (gal > 1000) {
            return "\(String(format: "%.2f", gal * 0.001)) kGal"
        }
        return "\(String(format: "%.2f", gal)) Gal"
    }

    static func cfToReadable(cf:Double) -> String {
        if (cf > 1000) {
            return "\(String(format: "%.3f", cf * 0.001)) Mcf"
        }
        return "\(String(format: "%.3f", cf)) cf"
    }

}
