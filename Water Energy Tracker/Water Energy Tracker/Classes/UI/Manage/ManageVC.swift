//
//  ManageVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 4/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import SwiftyBluetooth
import CoreBluetooth
import RealmSwift

class ManageVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var saviors:[RealmSavior] = []
    var peripherals:[Peripheral] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LIST_CELL")
        self.tableView.tableFooterView = UIView()
        
        let rightBarButton = UIBarButtonItem(title: "Add With Share Number", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManageVC.addShare(_:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
        scan()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addShare(_ sender:UIBarButtonItem!) {
        let alertController = UIAlertController(title: nil, message: "Enter Share Number", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let textFields = alertController.textFields,
                textFields.count > 0 else {
                    // Could not find textfield
                    return
            }
            
            let field = textFields[0]
            
            if field.text!.count > 0 {
                self.showHud()
                let req:GenericRequest = GenericRequest()
                req.name = field.text!
                AzureApi.shared.getNamesByShareNum(req: req, completionHandler: { (error:ServerError?, response:NamesResponse?) in
                    self.hideHud()
                    if let error = error {
                        self.showError(message: error.getMessage()!)
                    } else {
                        if let response = response {
                            let realm = try! Realm()
                            
                            if let Macid = response.Macid {
                                
                                let items = realm.objects(RealmSavior.self).filter("savior_address = '\(Macid)'")
                                if items.count > 0 {
                                    self.showError(message: "Device is already in your list.")
                                    return
                                }
                                
                                var newsavior:RealmSavior? = nil
                                DispatchQueue.main.async {
                                    try! realm.write {
                                        let savior:RealmSavior = RealmSavior()
                                        savior.share_number = response.ShareNumber
                                        savior.temp_share_number = response.TempShareNumber
                                        savior.from_share = true
                                        savior.savior_address = Macid
                                        savior.mac_address = Macid
                                        savior.is_registered = true
                                        savior.stype = Int(response.Stype!)!
                                        savior.alias = response.DeviceName
                                        savior.energy_unit_name_1 = response.Name1
                                        savior.energy_unit_name_2 = response.Name2
                                        savior.energy_unit_name_3 = response.Name3
                                        savior.energy_unit_name_4 = response.Name4
                                        savior.energy_unit_name_5 = response.Name5
                                        savior.energy_unit_name_6 = response.Name6
                                        savior.energy_unit_name_7 = response.Name7
                                        savior.energy_unit_name_8 = response.Name8
                                        
                                        realm.add(savior)
                                        newsavior = savior
                                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                                        object: nil,
                                                                        userInfo: nil)
                                    }
                                }
                                if let newsavior = newsavior {
                                    if newsavior.stype != Constants.water_stype {
                                        let config:DeviceConfiguration = DeviceConfiguration()
                                        config.name = newsavior.savior_address!
                                        self.showHud()
                                        AzureApi.shared.getConfig(req: config, completionHandler: { (error:ServerError?, response:DeviceConfiguration?) in
                                            self.hideHud()
                                            if let error = error {
                                                self.showError(message: error.getMessage()!)
                                            } else {
                                                if let response = response {
                                                    DispatchQueue.main.async {
                                                        try! realm.write {
                                                            newsavior.EnergyUnit = response.EnergyUnit
                                                            if let EnergyUnitPerPulse = response.EnergyUnitPerPulse {
                                                                newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                            }
                                                        }
                                                        self.scan()
                                                        self.tableView.reloadData()
                                                    }
                                                    
                                                }
                                            }
                                        })
                                    } else {
                                        DispatchQueue.main.async {
                                            self.scan()
                                            self.tableView.reloadData()
                                        }
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        self.scan()
                                        self.tableView.reloadData()
                                    }
                                }
                                
                            } else {
                                self.showError(message: response.retstring!)
                            }
                        }
                    }
                    
                })
                
            }
            
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Share "
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func scan() {
        let realm = try! Realm()
        realm.refresh()
        let items = realm.objects(RealmSavior.self)
        saviors.removeAll()
        saviors.append(contentsOf: items)
        self.tableView.reloadData()

        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: ["6e400001-b5a3-f393-e0a9-e50e24dcca9e"], timeoutAfter: 15) { scanResult in
            switch scanResult {
            case .scanStarted:
                // The scan started meaning CBCentralManager scanForPeripherals(...) was called
                self.peripherals.removeAll()
                break
            case .scanResult(let peripheral, let advertisementData, let RSSI):
                print("GOT BLUETOOTH \(peripheral.identifier) \(advertisementData) \(peripheral.name!)")
                // A peripheral was found, your closure may be called multiple time with a .ScanResult enum case.
                // You can save that peripheral for future use, or call some of its functions directly in this closure.
                if !self.peripherals.contains(where: { (per:Peripheral) -> Bool in
                    return per.identifier == peripheral.identifier
                }) {
                    
                    if !self.saviors.contains(where: { (sav:RealmSavior) -> Bool in
                        return sav.savior_address == peripheral.name!.replacingOccurrences(of: "SX", with: "")
                    }) {
                        
                        DispatchQueue.main.async {
                            self.peripherals.append(peripheral)
                            self.tableView.reloadData()
                        }
                        
                    }
                }
                break
            case .scanStopped(let error):
                // The scan stopped, an error is passed if the scan stopped unexpectedly
                break
            }
        }
        
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return self.saviors.count
        }
        return self.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "LIST_CELL", for: indexPath)
        if indexPath.section == 0 {
            let savior = self.saviors[indexPath.row]
            cell.textLabel?.text = savior.alias!
        } else {
            let peripheral = self.peripherals[indexPath.row]
            cell.textLabel?.text = peripheral.name!
        }
        
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "CONFIGURED TRACKERS"
        }
        return "NEW TRACKERS DISCOVERED"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0) {
            
        } else {
            let peripheral = self.peripherals[indexPath.row]
            self.showHud()
            let req:GenericRequest = GenericRequest()
            req.name = peripheral.name!.replacingOccurrences(of: "SX", with: "")
            AzureApi.shared.getNames(req: req, completionHandler: { (error:ServerError?, response:NamesResponse?) in
                self.hideHud()
                if let error = error {
                    self.showError(message: error.getMessage()!)
                } else {
                    if let response = response {
                        let realm = try! Realm()
                        var newsavior:RealmSavior? = nil
                        DispatchQueue.main.async {
                            try! realm.write {
                                let savior:RealmSavior = RealmSavior()
                                savior.share_number = response.ShareNumber
                                savior.temp_share_number = response.TempShareNumber
                                savior.from_share = false
                                savior.savior_address = peripheral.name!.replacingOccurrences(of: "SX", with: "")
                                savior.mac_address = peripheral.identifier.uuidString
                                savior.is_registered = true
                                savior.stype = Int(response.Stype!)!
                                savior.alias = response.DeviceName
                                savior.energy_unit_name_1 = response.Name1
                                savior.energy_unit_name_2 = response.Name2
                                savior.energy_unit_name_3 = response.Name3
                                savior.energy_unit_name_4 = response.Name4
                                savior.energy_unit_name_5 = response.Name5
                                savior.energy_unit_name_6 = response.Name6
                                savior.energy_unit_name_7 = response.Name7
                                savior.energy_unit_name_8 = response.Name8
                                
                                realm.add(savior)
                                newsavior = savior
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                                object: nil,
                                                                userInfo: nil)
                            }
                        }
                        if let newsavior = newsavior {
                            if newsavior.stype != Constants.water_stype {
                                let config:DeviceConfiguration = DeviceConfiguration()
                                config.name = newsavior.savior_address!
                                self.showHud()
                                AzureApi.shared.getConfig(req: config, completionHandler: { (error:ServerError?, response:DeviceConfiguration?) in
                                    self.hideHud()
                                    if let error = error {
                                        self.showError(message: error.getMessage()!)
                                    } else {
                                        if let response = response {
                                            DispatchQueue.main.async {
                                                try! realm.write {
                                                    newsavior.EnergyUnit = response.EnergyUnit
                                                    if let EnergyUnitPerPulse = response.EnergyUnitPerPulse {
                                                        newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                    }
                                                }
                                                self.peripherals.remove(at: indexPath.row)
                                                self.scan()
                                                self.tableView.reloadData()
                                            }
                                        }
                                    }
                                })
                            } else {
                                DispatchQueue.main.async {
                                    self.scan()
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.peripherals.remove(at: indexPath.row)
                                self.scan()
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
    }
}
