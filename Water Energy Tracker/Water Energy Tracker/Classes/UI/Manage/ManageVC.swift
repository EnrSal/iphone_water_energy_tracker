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

class ManageVC: SaviorVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var saviors:[RealmSavior] = []
    var peripherals:[Peripheral] = []
    var all_peripherals:[Peripheral] = []
    
    
    let RX_SERVICE_UUID:String = "6e400001-b5a3-f393-e0a9-e50e24dcca9e"
    let RX_CHAR_UUID:String = "6e400002-b5a3-f393-e0a9-e50e24dcca9e"
    
    
    
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
    
    let allowedCharacters = CharacterSet(charactersIn:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890 #-_").inverted

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let components = string.components(separatedBy: allowedCharacters)
        let filtered = components.joined(separator: "")
        
        if string == filtered {
            
            return true

        } else {
            
            return false
        }
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
                                        
                                        savior.share_number_prev = savior.share_number
                                        savior.share_number = response.ShareNumber
                                        savior.temp_share_number_prev = savior.temp_share_number
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
                                        savior.share_number_used = field.text!
                                        realm.add(savior)
                                        newsavior = savior
                                        NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                                        object: nil,
                                                                        userInfo: nil)
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
                                                            print("newsavior.stype = \(newsavior.stype) response.UnitPerPulse=\(response.UnitPerPulse)")
                                                            try! realm.write {
                                                                
                                                                if let unit = response.Unit, let unitperpulse = response.UnitPerPulse {
                                                                    newsavior.EnergyUnit = unit
                                                                    newsavior.EnergyUnitPerPulse = Double(unitperpulse)!
                                                                } else if let unit = response.EnergyUnit, let unitperpulse = response.EnergyUnitPerPulse {
                                                                    newsavior.EnergyUnit = unit
                                                                    newsavior.EnergyUnitPerPulse = Double(unitperpulse)!
                                                                }
                                                                /*
                                                                if newsavior.stype == 20 || newsavior.stype == 21 || newsavior.stype == 22 || newsavior.stype == 24 {
                                                                    newsavior.EnergyUnit = response.Unit
                                                                    if let EnergyUnitPerPulse = response.UnitPerPulse {
                                                                        newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                                    }
                                                                } else {
                                                                    newsavior.EnergyUnit = response.EnergyUnit
                                                                    if let EnergyUnitPerPulse = response.EnergyUnitPerPulse {
                                                                        newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                                    }
                                                                }*/
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
            textField.keyboardType = .numberPad
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
        self.all_peripherals.removeAll()
        
        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: [RX_SERVICE_UUID], timeoutAfter: 15) { scanResult in
            switch scanResult {
            case .scanStarted:
                // The scan started meaning CBCentralManager scanForPeripherals(...) was called
                self.peripherals.removeAll()
                break
            case .scanResult(let peripheral, let advertisementData, let RSSI):
                print("GOT BLUETOOTH \(peripheral.identifier) \(advertisementData) \(peripheral.name!)")
                if peripheral.name! == "SX." {
                    peripheral.connect(withTimeout: 3) { result in
                        print("CONNECT TO SX. \(result)")
                        peripheral.disconnect {result in
                            print("DISCONNECT TO SX. \(result)")
                        }
                    }
                    return
                }
                // A peripheral was found, your closure may be called multiple time with a .ScanResult enum case.
                // You can save that peripheral for future use, or call some of its functions directly in this closure.
                if !self.peripherals.contains(where: { (per:Peripheral) -> Bool in
                    return per.identifier == peripheral.identifier
                }) {
                    
                    self.all_peripherals.append(peripheral)
                    
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
            if let alias = savior.alias {
                cell.textLabel?.text = alias
            } else {
                cell.textLabel?.text = "no name"
            }
        } else {
            if self.peripherals.count > indexPath.row {
                let peripheral = self.peripherals[indexPath.row]
                cell.textLabel?.text = peripheral.name!
            }
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
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if (indexPath.section == 0) {
            let savior = self.saviors[indexPath.row]
            
            let alertController = UIAlertController(title: NSLocalizedString("Options", comment: ""), message: nil, preferredStyle: .actionSheet)
            
            if !savior.from_share {
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Configure Device", comment: ""), style: .default, handler: { action in
                    
                    
                    
                    
                    let sendVC:WifiConfigVC = WifiConfigVC(nibName: "WifiConfigVC", bundle: nil)
                    sendVC.savior = savior
                    
                    let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.navigationController!.present(nav, animated: true, completion: nil)
                    
                    
                    
                    /*
                     var found = false
                     for peripheral in self.all_peripherals {
                     if peripheral.name!.replacingOccurrences(of: "SX", with: "") == savior.savior_address! {
                     
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     
                     
                     
                     let sendVC:WifiConfigVC = WifiConfigVC(nibName: "WifiConfigVC", bundle: nil)
                     sendVC.savior = savior
                     
                     let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                     self.navigationController!.present(nav, animated: true, completion: nil)
                     
                     
                     
                     
                     
                     }
                     found = true
                     break
                     }
                     }
                     if !found{
                     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                     self.showError(message: "Device is not currently connected.")
                     }
                     }*/
                    
                }))
                
                
                
                
                
            }
            
            
            if !savior.from_share {
                if savior.is_configured {
                    // if (savior.stype != Constants.energy2_stype) && (savior.stype != Constants.energy4_stype) && (savior.stype != Constants.energy8_stype) {
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Send Data to Device", comment: ""), style: .default, handler: { action in
                        var found = false
                        for peripheral in self.all_peripherals {
                            if peripheral.name!.replacingOccurrences(of: "SX", with: "") == savior.savior_address! {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    
                                    
                                    
                                    let sendVC:WifiSendDataVC = WifiSendDataVC(nibName: "WifiSendDataVC", bundle: nil)
                                    sendVC.savior = savior
                                    sendVC.peripheral = peripheral
                                    let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                                    nav.modalPresentationStyle = .fullScreen
                                    self.navigationController!.present(nav, animated: true, completion: nil)
                                    
                                    
                                    
                                    
                                    
                                }
                                found = true
                                break
                            }
                        }
                        if !found{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.showError(message: "Device is not currently connected.")
                            }
                        }
                        
                    }))
                    // }
                }
            }
            
            if !savior.from_share {
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Set Names", comment: ""), style: .default, handler: { action in
                    
                    
                    
                    
                    
                    let alertController = UIAlertController(title: nil, message: "Device Names", preferredStyle: .alert)
                    
                    let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
                        guard let textFields = alertController.textFields,
                            textFields.count > 0 else {
                                // Could not find textfield
                                return
                        }
                        
                        let alias = textFields[0]
                        
                        if alias.text!.count > 0 {
                            
                            let realm = try! Realm()
                            try! realm.write {
                                
                                savior.alias = alias.text
                                if savior.stype == 1 || savior.stype == 21 || savior.stype == 2 || savior.stype == 22 || savior.stype == 4  || savior.stype == 24
                                    || savior.stype == 31 || savior.stype == 32 || savior.stype == 34 {
                                    savior.energy_unit_name_1 = textFields[1].text
                                    savior.energy_unit_name_2 = textFields[2].text
                                }
                                if savior.stype == 2 || savior.stype == 22 || savior.stype == 4  || savior.stype == 24 || savior.stype == 32 || savior.stype == 34 {
                                    savior.energy_unit_name_3 = textFields[3].text
                                    savior.energy_unit_name_4 = textFields[4].text
                                }
                                if savior.stype == 4 || savior.stype == 24 || savior.stype == 34 {
                                    savior.energy_unit_name_5 = textFields[5].text
                                    savior.energy_unit_name_6 = textFields[6].text
                                    savior.energy_unit_name_7 = textFields[7].text
                                    savior.energy_unit_name_8 = textFields[8].text
                                    
                                }
                                
                                
                                
                                
                                
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                                object: nil,
                                                                userInfo: nil)
                            }
                            
                            let genreq:GenericRequest = GenericRequest()
                            genreq.name = "\(savior.savior_address!),\(savior.alias!),\(savior.energy_unit_name_1!),\(savior.energy_unit_name_2!),\(savior.energy_unit_name_3!),\(savior.energy_unit_name_4!),\(savior.energy_unit_name_5!),\(savior.energy_unit_name_6!),\(savior.energy_unit_name_7!),\(savior.energy_unit_name_8!)"
                            
                            AzureApi.shared.setNames(req: genreq, completionHandler: { (error:ServerError?, response:GenericResponse?) in
                                if let error = error {
                                    print(error)
                                } else {
                                    if let response = response {
                                        
                                        
                                    }
                                }
                            })
                            
                            self.scan()
                            
                            
                        }
                        
                        
                    }
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                    
                    alertController.addTextField { (textField) in
                        textField.placeholder = "Name of Device"
                        textField.text = savior.alias!
                        textField.delegate = self
                    }
                    
                    if savior.stype == 1 || savior.stype == 21 || savior.stype == 2 || savior.stype == 22 || savior.stype == 4  || savior.stype == 24
                        || savior.stype == 31 || savior.stype == 32 || savior.stype == 34 {
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 1 name"
                            textField.text = savior.energy_unit_name_1!
                            textField.delegate = self
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 2 name"
                            textField.text = savior.energy_unit_name_2!
                            textField.delegate = self
                        }
                    }
                    if savior.stype == 2 || savior.stype == 22 || savior.stype == 4  || savior.stype == 24 || savior.stype == 32 || savior.stype == 34 {
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 3 name"
                            textField.text = savior.energy_unit_name_3!
                            textField.delegate = self
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 4 name"
                            textField.text = savior.energy_unit_name_4!
                            textField.delegate = self
                        }
                        
                    }
                    if savior.stype == 4 || savior.stype == 24 || savior.stype == 34 {
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 5 name"
                            textField.text = savior.energy_unit_name_5!
                            textField.delegate = self
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 6 name"
                            textField.text = savior.energy_unit_name_6!
                            textField.delegate = self
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 7 name"
                            textField.text = savior.energy_unit_name_7!
                            textField.delegate = self
                        }
                        alertController.addTextField { (textField) in
                            textField.placeholder = "Unit 8 name"
                            textField.text = savior.energy_unit_name_8!
                            textField.delegate = self
                        }
                    }
                    
                    
                    alertController.addAction(confirmAction)
                    alertController.addAction(cancelAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                    
                }))
            }
            if !savior.from_share {
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Show Share Number", comment: ""), style: .default, handler: { action in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        UIPasteboard.general.string = savior.share_number!
                        self.showError(message: "share number is: \(savior.share_number!) (saved to clipboard)")
                    }
                }))
            }
            
            if !savior.from_share {
                
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Show Read-Only Share Number", comment: ""), style: .default, handler: { action in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        if savior.stype == Constants.energy2_relay_stype || savior.stype == Constants.energy4_relay_stype || savior.stype == Constants.energy8_relay_stype {
                            let sendVC:TempShareVC = TempShareVC(nibName: "TempShareVC", bundle: nil)
                            sendVC.savior = savior
                            let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                            nav.modalPresentationStyle = .fullScreen
                            self.navigationController!.present(nav, animated: true, completion: nil)
                        } else {
                            UIPasteboard.general.string = savior.temp_share_number!
                            self.showError(message: "temporary share number is: \(savior.temp_share_number!) (saved to clipboard)")
                        }
                    }
                }))
            }
            
            var show = false
            if savior.stype == 20 || savior.stype == 21 || savior.stype == 22 || savior.stype == 24 || savior.stype == 31 || savior.stype == 32 || savior.stype == 34 || savior.stype == Constants.remote_well {
                show = true
                if let share_number_used = savior.share_number_used {
                    print("@@@ share_number_used.count =\(share_number_used.count)")
                    if share_number_used.count == 18 {
                        show = false
                    }
                    if share_number_used.count > 10 {
                        show = false
                    }
                }
                
            }
            
            if show {
                // schedule
                if savior.stype == 20 || savior.stype == 21 || savior.stype == 22 || savior.stype == 24 || savior.stype == Constants.energy2_relay_stype || savior.stype == Constants.energy4_relay_stype || savior.stype == Constants.energy8_relay_stype || savior.stype == Constants.remote_well {
                    alertController.addAction(UIAlertAction(title: NSLocalizedString("Schedule ON/OFF", comment: ""), style: .default, handler: { action in
                        let sendVC:ScheduleVC = ScheduleVC(nibName: "ScheduleVC", bundle: nil)
                        sendVC.savior = savior
                        let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                        nav.modalPresentationStyle = .fullScreen
                        self.navigationController!.present(nav, animated: true, completion: nil)
                    }))
                }
            }
            
            
            if show {
                alertController.addAction(UIAlertAction(title: NSLocalizedString("Send Command", comment: ""), style: .default, handler: { action in
                    let sendVC:SendCommandVC = SendCommandVC(nibName: "SendCommandVC", bundle: nil)
                    sendVC.savior = savior
                    let nav:UINavigationController = UINavigationController(rootViewController: sendVC)
                    nav.modalPresentationStyle = .fullScreen
                    self.navigationController!.present(nav, animated: true, completion: nil)
                }))
            }
            
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Delete Configuration", comment: ""), style: .destructive, handler: { action in
                let realm = try! Realm()
                try! realm.write {
                    realm.delete(savior)
                    NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                    object: nil,
                                                    userInfo: nil)
                }
                self.tableView.reloadData()
                self.scan()
                
            }))
            
            alertController.addAction(UIAlertAction(title:NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { action in
                
            }))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
        } else {
            let peripheral = self.peripherals[indexPath.row]
            self.showHud()
            let req:GenericRequest = GenericRequest()
            req.name = peripheral.name!.replacingOccurrences(of: "SX", with: "")
            print("############# GET NAMES")
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
                                savior.share_number_prev = savior.share_number
                                savior.share_number = response.ShareNumber
                                savior.temp_share_number_prev = savior.temp_share_number
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
                                print("############# 1 \(newsavior)")
                                
                                
                                print("############# 2 \(newsavior)")
                                if let newsavior = newsavior {
                                    print("############# 3 \(newsavior)")
                                    if newsavior.stype != Constants.water_stype {
                                        let config:DeviceConfiguration = DeviceConfiguration()
                                        config.name = newsavior.savior_address!
                                        self.showHud()
                                        print("############# GET CONFIG")
                                        AzureApi.shared.getConfig(req: config, completionHandler: { (error:ServerError?, response:DeviceConfiguration?) in
                                            self.hideHud()
                                            if let error = error {
                                                self.showError(message: error.getMessage()!)
                                            } else {
                                                if let response = response {
                                                    DispatchQueue.main.async {
                                                        try! realm.write {
                                                            
                                                            if newsavior.stype == 20 || newsavior.stype == 21 || newsavior.stype == 22 || newsavior.stype == 24 {
                                                                newsavior.EnergyUnit = response.Unit
                                                                if let EnergyUnitPerPulse = response.UnitPerPulse {
                                                                    newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                                }
                                                            } else {
                                                                newsavior.EnergyUnit = response.EnergyUnit
                                                                if let EnergyUnitPerPulse = response.EnergyUnitPerPulse {
                                                                    newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                                } else if let EnergyUnitPerPulse = response.UnitPerPulse {
                                                                    newsavior.EnergyUnitPerPulse = Double(EnergyUnitPerPulse)!
                                                                }

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
                                
                                NotificationCenter.default.post(name:NSNotification.Name(rawValue:"DeviceAddedEvent"),
                                                                object: nil,
                                                                userInfo: nil)
                                
                                
                                
                            }
                        }
                        
                    }
                }
            })
        }
    }
}
