//
//  GraphPoint.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/3/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class GraphPoint: NSObject {
    var time:Double!
    var value:Double!
    
    convenience init(from time: Double, value:Double) {
        self.init()
        self.time = time
        self.value = value
    }
}
