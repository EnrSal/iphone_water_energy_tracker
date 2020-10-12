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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            time.text = item.UTCtime
            type.text = item.DataType
            value.text = "\(item.DataValue!)"
        }
    }
    
}
