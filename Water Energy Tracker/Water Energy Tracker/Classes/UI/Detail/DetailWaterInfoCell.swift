//
//  DetailWaterInfoCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/10/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailWaterInfoCell: UITableViewCell {

    var savior: RealmSavior!
    @IBOutlet weak var detections_day: UILabel!
    @IBOutlet weak var detections_hour: UILabel!
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var info: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate() {
        let realm = try! Realm()
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
        if items.count > 0 {
            let current = items.first
            
            if current!.Indicator! == ">" || current!.Alarm! == "A" || current!.Alarm! == "a" || current!.Alarm! == "m" || current!.Alarm! == "n" || current!.Alarm! == "F" ||
                current!.Alarm! == "f" || current!.Alarm! == "1" || current!.Alarm! == "2" || current!.Alarm! == "3" || current!.Alarm! == "5" || current!.Alarm! == "6" || current!.Alarm! == "7" {
                
                if current!.SolMinutes > 1 {
                    let mins = current!.SolMinutes / 60;
                    info.text = "ON for \(mins) Minutes"
                } else {
                    info.text = "Movement detected on last update"
                }
                info.textColor = UIColor.green
            } else {
                info.text = "No Movement detected on last update"
                info.textColor = UIColor.red
            }
            
            self.temp1.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temperature))) °F"
            self.temp2.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temp2))) °F"
            
            self.detections_hour.text = "\(current!.Hourly)"
            self.detections_day.text = "\(current!.Daily)"
        }

    }
    
}
