//
//  TimeZoneCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 12/20/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class TimeZoneCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var timezone: UITextField!
    var picker: UIPickerView! = UIPickerView()
    let timezones:[String] = ["Pacific","Mountain","Central","Eastern","Atlantic","Newfoundland"]
    var owner:SettingsVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timezone.inputView = self.picker
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsVC.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.timezone.inputAccessoryView = keyboardToolbar
        self.picker.delegate = self
        self.picker.dataSource = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Picker
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        print("TIMEZONES \(timezones.count)")
        return timezones.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timezones[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.owner.config!.TimeZone = timezones[row]
        self.timezone.text = self.owner.config!.TimeZone!
    }
    
    func populate() {
        self.timezone.text = self.owner.config!.TimeZone!

    }
}
