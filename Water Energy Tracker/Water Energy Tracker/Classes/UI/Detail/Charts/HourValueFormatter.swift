//
//  HourValueFormatter.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts

class HourValueFormatter: NSObject, IAxisValueFormatter {

    let time_formatter = DateFormatter()
    var countToDate:[Double:Double] = [:]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        time_formatter.dateFormat = "h:mm a" //
        time_formatter.timeZone = TimeZone(abbreviation: "UTC")

        print("GET DATE FOR -->\(value)")
        if let val = countToDate[value] {
            let date = Date(timeIntervalSince1970: val)
            
            return time_formatter.string(from: date)
        }
        
        return time_formatter.string(from: Date())
    }
}
