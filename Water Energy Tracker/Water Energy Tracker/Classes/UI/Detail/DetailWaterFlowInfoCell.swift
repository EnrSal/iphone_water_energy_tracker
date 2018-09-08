//
//  DetailWaterFlowInfoCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 9/7/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailWaterFlowInfoCell: DetailEnergyInfoCell {

    @IBOutlet weak var detections_day: UILabel!
    @IBOutlet weak var detections_hour: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func populate() {
        super.populate()
        let realm = try! Realm()
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
        if items.count > 0 {
            let current = items.first
            
            self.detections_hour.text = "\(current!.Hourly)"
            self.detections_day.text = "\(current!.Daily)"
        }
        
    }

    
}
