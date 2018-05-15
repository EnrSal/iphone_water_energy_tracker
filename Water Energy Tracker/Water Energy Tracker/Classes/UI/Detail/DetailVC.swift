//
//  DetailVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/10/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var timeago: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var energy_unit:Int = 0
    var savior: RealmSavior!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let utilityButton = UIBarButtonItem(title: "Utility", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickUtility(_:)))
        let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickSettings(_:)))
        let historyButton = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickHistory(_:)))
        self.navigationItem.rightBarButtonItems = [historyButton,settingsButton,utilityButton]

        
        self.tableView.register(DetailWaterInfoCell.self, forCellReuseIdentifier: "WATER_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailWaterInfoCell", bundle: nil), forCellReuseIdentifier: "WATER_INFO_CELL")
        
        self.tableView.register(DetailEnergyInfoCell.self, forCellReuseIdentifier: "ENERGY_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailEnergyInfoCell", bundle: nil), forCellReuseIdentifier: "ENERGY_INFO_CELL")
        
        self.tableView.register(EnergyPowerUsageChartCell.self, forCellReuseIdentifier: "ENERGY_POWER_CHART")
        self.tableView.register(UINib(nibName: "EnergyPowerUsageChartCell", bundle: nil), forCellReuseIdentifier: "ENERGY_POWER_CHART")
        
        self.tableView.register(WaterIntensityChartCell.self, forCellReuseIdentifier: "WATER_INTENSITY_CHART")
        self.tableView.register(UINib(nibName: "WaterIntensityChartCell", bundle: nil), forCellReuseIdentifier: "WATER_INTENSITY_CHART")

        self.tableView.register(TemperatureChartCell.self, forCellReuseIdentifier: "TEMP_CHART")
        self.tableView.register(UINib(nibName: "TemperatureChartCell", bundle: nil), forCellReuseIdentifier: "TEMP_CHART")

        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        self.populate()
        
    }
    
    @objc func clickUtility(_ sender:UIBarButtonItem!) {

    }
    @objc func clickSettings(_ sender:UIBarButtonItem!) {
        let detailVC:SettingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        detailVC.savior = self.savior
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    @objc func clickHistory(_ sender:UIBarButtonItem!) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func populate() {
        
        self.timeago.text = ""
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "MM/dd/yyyy h:mm a"
        
        let realm = try! Realm()
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
        if items.count > 0 {
            let current = items.first
            
            
            if let timestamp = current!.timestamp {
                self.time.text = date_formatter.string(from: timestamp)
                self.timeago.text = Util.timeAgoSinceDate(date: timestamp as NSDate, numericDates: true)
            }
            
            
            
        }
        
        
        if (self.savior.stype == 0) {
            name.text = self.savior.alias!
        } else {
            
            print("ENERGY UNIT \(energy_unit)")
            switch self.energy_unit {
            case 1:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_1!)"
            case 2:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_2!)"
            case 3:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_3!)"
            case 4:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_4!)"
            case 5:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_5!)"
            case 6:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_6!)"
            case 7:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_7!)"
            case 8:
                name.text = "\(self.savior.alias!) -- \(self.savior.energy_unit_name_8!)"
            default:
                break
            }
        }
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if (self.savior.stype == 0) {
                let cell:DetailWaterInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INFO_CELL", for: indexPath) as? DetailWaterInfoCell)!
                
                cell.savior = self.savior
                cell.populate()
                
                return cell;
            }
            
            let cell:DetailEnergyInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_INFO_CELL", for: indexPath) as? DetailEnergyInfoCell)!
            
            cell.savior = self.savior
            cell.energy_unit = self.energy_unit
            cell.populate()
            
            return cell;
        case 1:
            if (self.savior.stype == 0) {

                let cell:WaterIntensityChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INTENSITY_CHART", for: indexPath) as? WaterIntensityChartCell)!
                
                cell.end = Date()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;

            } else {
                let cell:EnergyPowerUsageChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_POWER_CHART", for: indexPath) as? EnergyPowerUsageChartCell)!
                
                cell.end = Date()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;

            }
        case 2:
            let cell:TemperatureChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_CHART", for: indexPath) as? TemperatureChartCell)!
            
            cell.end = Date()
            let calendar = NSCalendar.autoupdatingCurrent
            cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
            cell.savior = self.savior
            cell.energy_unit = self.energy_unit
            cell.populate()
            
            return cell;
        default:
            break
        }
        return UITableViewCell()

    }
    
}
