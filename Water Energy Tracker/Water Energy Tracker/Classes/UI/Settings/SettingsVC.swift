//
//  SettingsVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class SettingsVC: SaviorVC, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var footer: UIView!
    @IBOutlet weak var timezone: UITextField!
    var savior: RealmSavior!
    var config: DeviceConfiguration? = nil
    @IBOutlet weak var tableView: UITableView!
    var picker: UIPickerView! = UIPickerView()
    let timezones:[String] = ["Pacific","Mountain","Central","Eastern","Atlantic","Newfoundland"]
    
    enum SettingsType: Int {
        case temp_low
        case temp_high
        case user_calibration
       // case timezone
        case kwhour
        case kwday
        case kwweek
        case kwmonth
        case water
        case detections_day
        case detections_hour
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsVC.clickSave(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        //self.makeBackButton()
        
        self.title = "Alerts Settings"
        
        self.tableView.register(SettingsSliderCell.self, forCellReuseIdentifier: "SETTINGS_SLIDER_CELL")
        self.tableView.register(UINib(nibName: "SettingsSliderCell", bundle: nil), forCellReuseIdentifier: "SETTINGS_SLIDER_CELL")
        
        self.tableView.tableFooterView = self.footer
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .singleLine

        timezone.inputView = self.picker
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SettingsVC.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.timezone.inputAccessoryView = keyboardToolbar
        self.picker.delegate = self
        self.picker.dataSource = self

        self.showHud()
        let req:DeviceConfiguration = DeviceConfiguration()
        req.name = savior.savior_address!
        
        AzureApi.shared.getConfig(req: req) { (error:ServerError?, response:DeviceConfiguration?) in
            self.hideHud()
            if let error = error {
                self.showError(message: error.getMessage()!)
            } else {
                if let response = response {
                    self.config = response
                    self.config!.name = self.savior.savior_address!
                    self.populate()
                }
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
        self.config!.TimeZone = timezones[row]
        self.timezone.text = self.config!.TimeZone!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clickSave(_ sender:UIBarButtonItem!) {
        if let config = self.config {
            self.showHud()
            AzureApi.shared.setConfig(req: config) { (error:ServerError?, response:GenericResponse?) in
                self.hideHud()
                if let error = error {
                    self.showError(message: error.getMessage()!)
                } else {
                    if response != nil {
                        self.showError(message: "Successfully Updated!")
                    }
                }
                
            }
        }
    }
    
    func populate() {
        self.timezone.text = self.config!.TimeZone!
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.config != nil {
            if (self.savior.stype == 0) {
                return 6
            } else {
                return 7
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SettingsSliderCell = (self.tableView.dequeueReusableCell(withIdentifier: "SETTINGS_SLIDER_CELL", for: indexPath) as? SettingsSliderCell)!
        cell.owner = self
        if (self.savior.stype == 0) {
            switch indexPath.row {
            case 0:
                cell.type = .water
            case 1:
                cell.type = .temp_low
            case 2:
                cell.type = .temp_high
            case 3:
                cell.type = .user_calibration
            case 4:
                cell.type = .detections_hour
            case 5:
                cell.type = .detections_day
            default:
                break
            }
        } else {
            switch indexPath.row {
            case 0:
                cell.type = .kwhour
            case 1:
                cell.type = .kwday
            case 2:
                cell.type = .kwweek
            case 3:
                cell.type = .kwmonth
            case 4:
                cell.type = .temp_low
            case 5:
                cell.type = .temp_high
            case 6:
                cell.type = .user_calibration
            default:
                break
            }
        }

        cell.populate()
        
        
        return cell;
    }
    

}
