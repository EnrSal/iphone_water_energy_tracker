//
//  SettingsSliderCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class SettingsSliderCell: UITableViewCell {

    @IBOutlet weak var currentEdut: UITextField!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    
    var type:SettingsVC.SettingsType? = nil
    var owner:SettingsVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        
    }
    
    func populate() {
        
    }
    
}
