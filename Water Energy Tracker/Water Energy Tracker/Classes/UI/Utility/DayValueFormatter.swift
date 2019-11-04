//
//  DayValueFormatter.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/3/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts

class DayValueFormatter: NSObject, IAxisValueFormatter {

    let time_formatter = DateFormatter()
    var countToDate:[Double:Double] = [:]

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        time_formatter.dateFormat = "MM/dd" //
        time_formatter.timeZone = TimeZone(abbreviation: "UTC")

        print("GET DATE FOR -->\(value)")
        if let val = countToDate[value] {
            let date = Date(timeIntervalSince1970: val)
            
            return time_formatter.string(from: date)
        }
        
        return time_formatter.string(from: Date())
    }
}
