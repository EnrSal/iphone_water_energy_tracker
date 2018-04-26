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
        scan()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scan() {
        SwiftyBluetooth.scanForPeripherals(withServiceUUIDs: ["6e400001-b5a3-f393-e0a9-e50e24dcca9e"], timeoutAfter: 15) { scanResult in
            switch scanResult {
            case .scanStarted:
            // The scan started meaning CBCentralManager scanForPeripherals(...) was called
                break
            case .scanResult(let peripheral, let advertisementData, let RSSI):
                print("GOT BLUETOOTH \(peripheral.identifier) \(advertisementData) \(peripheral.name!)")
                // A peripheral was found, your closure may be called multiple time with a .ScanResult enum case.
            // You can save that peripheral for future use, or call some of its functions directly in this closure.
                if !self.peripherals.contains(where: { (per:Peripheral) -> Bool in
                    return per.identifier == peripheral.identifier
                }) {
                    DispatchQueue.main.async {
                        self.peripherals.append(peripheral)
                        self.tableView.reloadData()
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
                            
                        }
                    }
                }
            })
        }
    }
}
