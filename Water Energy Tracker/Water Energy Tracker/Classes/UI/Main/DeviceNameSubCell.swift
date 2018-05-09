//
//  DeviceNameSubCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/8/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class DeviceNameSubCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
