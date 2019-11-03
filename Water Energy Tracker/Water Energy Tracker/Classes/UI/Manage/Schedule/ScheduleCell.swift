//
//  ScheduleCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/2/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import M13Checkbox

class ScheduleCell: UICollectionViewCell {

    var item:ScheduleItem!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var checkbox: M13Checkbox!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    @IBAction func clickCheck(_ sender: Any) {
        print("CLICK \(checkbox.checkState)" )
        if checkbox.checkState == .checked {
            item.on = true
        } else {
            item.on = false
        }
    }
    
    func populate() {
        let hour = item.index
        if hour <= 11 {
            if hour == 0 {
                self.time.text = "12am"
            } else {
                self.time.text = "\(hour)am"
            }
        } else {
            if hour == 12 {
                self.time.text = "12pm"
            } else {
                self.time.text = "\(hour-12)pm"
            }
        }
        
        if item.on {
            checkbox.checkState = .checked
        } else {
            checkbox.checkState = .unchecked
        }
    }
}
