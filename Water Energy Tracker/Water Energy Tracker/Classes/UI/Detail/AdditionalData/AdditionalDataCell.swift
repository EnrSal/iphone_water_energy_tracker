//
//  AdditionalDataCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 10/11/20.
//  Copyright © 2020 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class AdditionalDataCell: UITableViewCell {

    var item:AdditionalDataItem!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        time.layer.borderWidth = 1
        time.layer.borderColor = UIColor.black.cgColor

        type.layer.borderWidth = 1
        type.layer.borderColor = UIColor.black.cgColor

        station.layer.borderWidth = 1
        station.layer.borderColor = UIColor.black.cgColor

        from.layer.borderWidth = 1
        from.layer.borderColor = UIColor.black.cgColor

        value.layer.borderWidth = 1
        value.layer.borderColor = UIColor.black.cgColor
        
        let screenSize = UIScreen.main.bounds
        widthConstraint.constant = screenSize.width * 0.4
    }

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var from: UILabel!
    @IBOutlet weak var value: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        

    }
    
    func populate() {
        if item.header {
            from.text = "From"
            station.text = "Station"
            time.text = "Time"
            type.text = "Type"
            value.text = "Value"
        } else {
            from.text = "\(item.SatelliteFrom!)"
            station.text = "\(item.BaseStationNameId!)"
            type.text = item.DataType
            value.text = "\(item.DataValue!)"
            
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            formatter2.timeZone = TimeZone(abbreviation: "UTC")
            let date = formatter2.date(from: item.UTCtime!)!
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy h:m a"
            time.text = formatter.string(from: date)
        }
    }
    
}
