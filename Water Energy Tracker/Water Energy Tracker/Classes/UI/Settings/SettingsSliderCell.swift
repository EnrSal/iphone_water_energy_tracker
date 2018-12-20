//
//  SettingsSliderCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class SettingsSliderCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var currentEdut: UITextField!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    
    var type:SettingsVC.SettingsType? = nil
    var owner:SettingsVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.currentEdut.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        slider.value = roundf(slider.value)
        switch self.type! {
        case .temp_low:
            self.owner.config!.TempLow! = String(format: "%.0f", slider.value)
        case .temp_high:
            self.owner.config!.TempHigh! = String(format: "%.0f", slider.value)
        case .user_calibration:
            self.owner.config!.UserTempCalib! = String(format: "%.0f", slider.value)
        case .kwhour:
            self.owner.config!.Hour! = String(format: "%.0f", slider.value)
        case .kwday:
            self.owner.config!.Day! = String(format: "%.0f", slider.value)
        case .kwweek:
            self.owner.config!.Week! = String(format: "%.0f", slider.value)
        case .kwmonth:
            self.owner.config!.Month! = String(format: "%.0f", slider.value)
        case .water:
            self.owner.config!.WaterFlowing! = String(format: "%.0f", slider.value)
        case .detections_hour:
            self.owner.config!.DetectionsHour! = String(format: "%.0f", slider.value)
        case .detections_day:
            self.owner.config!.DetectionsDay! = String(format: "%.0f", slider.value)
        }

        self.currentEdut.text = "\(Int(slider.value))"
    }
    
    func textFieldDidEndEditing(_ textField: UITextField,
                                reason: UITextFieldDidEndEditingReason) {
        if textField.text!.count > 0 {
            slider.value = roundf(Float(textField.text!)!)
            switch self.type! {
            case .temp_low:
                self.owner.config!.TempLow! = textField.text!
            case .temp_high:
                self.owner.config!.TempHigh! = textField.text!
            case .user_calibration:
                self.owner.config!.UserTempCalib! = textField.text!
            case .kwhour:
                self.owner.config!.Hour! = textField.text!
            case .kwday:
                self.owner.config!.Day! = textField.text!
            case .kwweek:
                self.owner.config!.Week! = textField.text!
            case .kwmonth:
                self.owner.config!.Month! = textField.text!
            case .water:
                self.owner.config!.WaterFlowing! = textField.text!
            case .detections_hour:
                self.owner.config!.DetectionsHour! = textField.text!
                print("DETECTIONS HOUR -->\(self.owner.config!.DetectionsHour!)")
            case .detections_day:
                self.owner.config!.DetectionsDay! = textField.text!
            }
        } else {
            slider.value = 0
        }
        //self.currentEdut.text = "\(Int(slider.value))"
    }
    
    
    func populate() {
        switch self.type! {
        case .temp_low:
            titleLabel.text = "Low Temperature (Fahrenheit):"
            slider.minimumValue = -20
            slider.maximumValue = 180
            self.maxLabel.text = "180"
            if self.owner.config!.TempLow == nil {
                self.owner.config!.TempLow = "0"
            }
            slider.value = Float(self.owner.config!.TempLow!)!
            print("LOW TEMP \(self.owner.config!.TempLow!)")
            print("slider.value \(slider.value)")
            self.currentEdut.text = "\(Int(self.owner.config!.TempLow!)!)"
        case .temp_high:
            titleLabel.text = "High Temperature (Fahrenheit):"
            slider.minimumValue = 0
            slider.maximumValue = 180
            self.maxLabel.text = "180"
            if self.owner.config!.TempHigh == nil {
                self.owner.config!.TempHigh = "0"
            }
            slider.value = Float(self.owner.config!.TempHigh!)!
            self.currentEdut.text = "\(Int(self.owner.config!.TempHigh!)!)"
        case .user_calibration:
            titleLabel.text = "User Temp Calibration:"
            slider.minimumValue = -20
            slider.maximumValue = 20
            self.maxLabel.text = "20"
            if self.owner.config!.UserTempCalib == nil {
                self.owner.config!.UserTempCalib = "0"
            }
            slider.value = Float(self.owner.config!.UserTempCalib!)!
            self.currentEdut.text = "\(Int(self.owner.config!.UserTempCalib!)!)"
        case .kwhour:
            slider.maximumValue = 100
            self.maxLabel.text = "100"
            titleLabel.text = "Kilo Watts used in 1 hour:"
            if self.owner.savior.stype >= 20 {
                titleLabel.text = "Gallons used in 1 hour:"
                slider.maximumValue = 500
                self.maxLabel.text = "500"
            }
            slider.minimumValue = 0
            if self.owner.config!.Hour == nil {
                self.owner.config!.Hour = "0"
            }
            slider.value = Float(self.owner.config!.Hour!)!
            self.currentEdut.text = "\(Int(self.owner.config!.Hour!)!)"
        case .kwday:
            titleLabel.text = "Kilo Watts used in 1 day:"
            slider.maximumValue = 1500
            self.maxLabel.text = "1500"
            if self.owner.savior.stype >= 20 {
                titleLabel.text = "Gallons used in 1 day:"
                slider.maximumValue = 3000
                self.maxLabel.text = "3000"
            }
            slider.minimumValue = 0
            if self.owner.config!.Day == nil {
                self.owner.config!.Day = "0"
            }
            slider.value = Float(self.owner.config!.Day!)!
            self.currentEdut.text = "\(Int(self.owner.config!.Day!)!)"
        case .kwweek:
            titleLabel.text = "Kilo Watts used in 1 week:"
            slider.maximumValue = 500000
            self.maxLabel.text = "500k"
            if self.owner.savior.stype >= 20 {
                titleLabel.text = "Gallons used in 1 week:"
                slider.maximumValue = 20000
                self.maxLabel.text = "20k"
            }
            slider.minimumValue = 0
            if self.owner.config!.Week == nil {
                self.owner.config!.Week = "0"
            }
            slider.value = Float(self.owner.config!.Week!)!
            self.currentEdut.text = "\(Int(self.owner.config!.Week!)!)"
        case .kwmonth:
            titleLabel.text = "Kilo Watts used in 1 month:"
            if self.owner.savior.stype >= 20 {
                titleLabel.text = "Gallons used in 1 month:"
            }
            slider.minimumValue = 0
            slider.maximumValue = 2000000
            self.maxLabel.text = "2000k"
            if self.owner.config!.Month == nil {
                self.owner.config!.Month = "0"
            }
            slider.value = Float(self.owner.config!.Month!)!
            self.currentEdut.text = "\(Int(self.owner.config!.Month!)!)"
        case .water:
            titleLabel.text = "Water flowing for more than (mins):"
            slider.minimumValue = 3
            slider.maximumValue = 30
            self.maxLabel.text = "30"
            if self.owner.config!.WaterFlowing == nil {
                self.owner.config!.WaterFlowing = "0"
            }
            slider.value = Float(self.owner.config!.WaterFlowing!)!
            self.currentEdut.text = "\(Int(self.owner.config!.WaterFlowing!)!)"
        case .detections_hour:
            titleLabel.text = "Number of detections in last hour:"
            slider.minimumValue = 5
            slider.maximumValue = 20
            self.maxLabel.text = "20"
            if self.owner.config!.DetectionsHour == nil {
                self.owner.config!.DetectionsHour = "0"
            }
            slider.value = Float(self.owner.config!.DetectionsHour!)!
            self.currentEdut.text = "\(Int(self.owner.config!.DetectionsHour!)!)"
        case .detections_day:
            titleLabel.text = "Number of detections in last day:"
            slider.minimumValue = 20
            slider.maximumValue = 400
            self.maxLabel.text = "400"
            if self.owner.config!.DetectionsDay == nil {
                self.owner.config!.DetectionsDay = "0"
            }
            slider.value = Float(self.owner.config!.DetectionsDay!)!
            self.currentEdut.text = "\(Int(self.owner.config!.DetectionsDay!)!)"
        }
    }
    
}
