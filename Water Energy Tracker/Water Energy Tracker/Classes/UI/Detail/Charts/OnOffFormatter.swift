//
//  OnOffFormatter.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 10/11/20.
//  Copyright © 2020 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts

class OnOffFormatter: NSObject, IAxisValueFormatter {

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if value == 1 {
            return "ON"
        } else if value == 0 {
            return "OFF"
        }
        return ""
    }

}
