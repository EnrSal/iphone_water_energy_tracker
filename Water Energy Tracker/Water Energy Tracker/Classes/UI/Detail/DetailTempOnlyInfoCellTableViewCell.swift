//
//  DetailTempOnlyInfoCellTableViewCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/9/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailTempOnlyInfoCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp1: UILabel!
    var savior: RealmSavior!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            
            self.temp1.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temperature))) °F"
            self.temp2.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temp2))) °F"
            
        }
    }
    
}
