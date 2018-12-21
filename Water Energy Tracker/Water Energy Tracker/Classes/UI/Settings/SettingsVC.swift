//
//  SettingsVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/14/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class SettingsVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet var footer: UIView!
    var savior: RealmSavior!
    var config: DeviceConfiguration? = nil
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.tableView.register(SolenoidSettingsCell.self, forCellReuseIdentifier: "SOLENOID_SETTINGS_CELL")
        self.tableView.register(UINib(nibName: "SolenoidSettingsCell", bundle: nil), forCellReuseIdentifier: "SOLENOID_SETTINGS_CELL")

        self.tableView.register(TimeZoneCell.self, forCellReuseIdentifier: "TIMEZONE_CELL")
        self.tableView.register(UINib(nibName: "TimeZoneCell", bundle: nil), forCellReuseIdentifier: "TIMEZONE_CELL")
    
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .singleLine


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
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.config == nil {
            return 0
        }
        if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24) {
            return 3
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2 {
            return 1
        }
        
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
        
        if indexPath.section == 1 {
            let cell:TimeZoneCell = (self.tableView.dequeueReusableCell(withIdentifier: "TIMEZONE_CELL", for: indexPath) as? TimeZoneCell)!
            cell.owner = self
            cell.populate()
            return cell
        }
        
        if indexPath.section == 2 {
            let cell:SolenoidSettingsCell = (self.tableView.dequeueReusableCell(withIdentifier: "SOLENOID_SETTINGS_CELL", for: indexPath) as? SolenoidSettingsCell)!
            cell.savior = self.savior
            cell.populate()
            return cell
        }

        
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
