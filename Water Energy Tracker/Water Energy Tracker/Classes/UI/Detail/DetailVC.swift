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

    var additiona_data:[AdditionalDataItem] = []
    
    var energy_unit:Int = 0
    var savior: RealmSavior!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let utilityButton = UIBarButtonItem(title: "Utility", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickUtility(_:)))
       // let settingsButton = UIBarButtonItem(title: "Settings", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickSettings(_:)))
      
        let buttonBack: UIButton = UIButton(type: UIButtonType.custom) as UIButton
        buttonBack.frame = CGRect(x: 0, y: 0, width: 40, height: 40) // CGFloat, Double, Int
        buttonBack.setImage(#imageLiteral(resourceName: "baseline_settings_white_36pt"), for: UIControlState.normal)
        buttonBack.addTarget(self, action: #selector(DetailVC.clickSettings(_:)), for: UIControlEvents.touchUpInside)
        
        let settingsButton: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)

        
        var from_share = false
        if savior.from_share {
            if let share_number_used = savior.share_number_used {
                if share_number_used.count > 10 {
                    from_share = true
                }
            }
        }
        
        print("DETAIL STYPE \(self.savior.stype)")
        
        let historyButton = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailVC.clickHistory(_:)))
        if (self.savior.stype == 0) || self.savior.stype == Constants.temperature_only_stype || self.savior.stype == Constants.remote_well {
            if from_share {
                self.navigationItem.rightBarButtonItems = [historyButton]
            } else {
                self.navigationItem.rightBarButtonItems = [historyButton,settingsButton]
            }
        } else {
            if from_share {
                self.navigationItem.rightBarButtonItems = [historyButton,utilityButton]
            } else {
                self.navigationItem.rightBarButtonItems = [historyButton,settingsButton,utilityButton]
            }
        }
        
        self.tableView.register(DetailWaterInfoCell.self, forCellReuseIdentifier: "WATER_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailWaterInfoCell", bundle: nil), forCellReuseIdentifier: "WATER_INFO_CELL")
        
        self.tableView.register(DetailWaterFlowInfoCell.self, forCellReuseIdentifier: "WATER_INFO_FLOW_CELL")
        self.tableView.register(UINib(nibName: "DetailWaterFlowInfoCell", bundle: nil), forCellReuseIdentifier: "WATER_INFO_FLOW_CELL")

        self.tableView.register(DetailEnergyInfoCell.self, forCellReuseIdentifier: "ENERGY_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailEnergyInfoCell", bundle: nil), forCellReuseIdentifier: "ENERGY_INFO_CELL")
        
        self.tableView.register(EnergyPowerUsageChartCell.self, forCellReuseIdentifier: "ENERGY_POWER_CHART")
        self.tableView.register(UINib(nibName: "EnergyPowerUsageChartCell", bundle: nil), forCellReuseIdentifier: "ENERGY_POWER_CHART")
        
        self.tableView.register(WaterIntensityChartCell.self, forCellReuseIdentifier: "WATER_INTENSITY_CHART")
        self.tableView.register(UINib(nibName: "WaterIntensityChartCell", bundle: nil), forCellReuseIdentifier: "WATER_INTENSITY_CHART")

        self.tableView.register(TemperatureChartCell.self, forCellReuseIdentifier: "TEMP_CHART")
        self.tableView.register(UINib(nibName: "TemperatureChartCell", bundle: nil), forCellReuseIdentifier: "TEMP_CHART")

        self.tableView.register(DetailTempOnlyInfoCellTableViewCell.self, forCellReuseIdentifier: "TEMP_ONLY_INFO_CELL")
        self.tableView.register(UINib(nibName: "DetailTempOnlyInfoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "TEMP_ONLY_INFO_CELL")

        self.tableView.register(RemoteWellOnOffChartCell.self, forCellReuseIdentifier: "REMOTE_WELL_CHART")
        self.tableView.register(UINib(nibName: "RemoteWellOnOffChartCell", bundle: nil), forCellReuseIdentifier: "REMOTE_WELL_CHART")

        self.tableView.register(AdditionalDataCell.self, forCellReuseIdentifier: "ADDITIONAL_DATA_CELL")
        self.tableView.register(UINib(nibName: "AdditionalDataCell", bundle: nil), forCellReuseIdentifier: "ADDITIONAL_DATA_CELL")

        
        
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        self.populate()
        
    }
    
    @objc func clickUtility(_ sender:UIBarButtonItem!) {
        let detailVC:EnergyUtilityVC = EnergyUtilityVC(nibName: "EnergyUtilityVC", bundle: nil)
        detailVC.savior = self.savior
        detailVC.energy_unit = self.energy_unit
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    @objc func clickSettings(_ sender:UIBarButtonItem!) {
        let detailVC:SettingsVC = SettingsVC(nibName: "SettingsVC", bundle: nil)
        detailVC.savior = self.savior
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func didChange(toDate date: Date) {
        print("SELECT DATE \(date)")
    }

    @objc func clickHistory(_ sender:UIBarButtonItem!) {
        
        let alert = UIAlertController(style: .actionSheet, title: "Select Date")
        alert.addDatePicker(mode: .dateAndTime, date: Date(), minimumDate: nil, maximumDate: Date()) { dt in
            print("SELECT DATE \(dt)")
            let formatter = DateFormatter()
            // formatter.calendar = Calendar(identifier: .iso8601)
            // formatter.locale = Locale(identifier: "en_US_POSIX")
            // formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "MMddyyyyHH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "UTC")
            
            let datestr = formatter.string(from: dt.startOfDay)
            
            let req:GetDataRequest = GetDataRequest()
            req.mac = self.savior.savior_address!
            req.stype = self.savior.stype
            req.utct = datestr
            print("@@@ req.utct \(req.utct)")
            
            self.showHud()
            AzureApi.shared.getData(req: req, completionHandler: { (error:ServerError?, response:GetDataResponse?, orig:String) in
                self.hideHud()
                if let error = error {
                    print(error)
                } else {
                    if let response = response {
                        
                        let realm = try! Realm()
                        try! realm.write {
                            for device in response.Result {
                                if device.UTCtime != nil && device.mac != nil {
                                    let dataPoint:RealmDataPoint = RealmDataPoint(fromDataPoint: device)
                                    let current = realm.objects(RealmDataPoint.self).filter("identifier = '\(dataPoint.identifier!)'").first
                                    if current == nil {
                                        realm.add(dataPoint)
                                        //print("ADDED \(dataPoint)")
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            let detailVC:HistoryVC = HistoryVC(nibName: "HistoryVC", bundle: nil)
                            detailVC.savior = self.savior
                            
                            
                            print("@@@ ORIG DATE \(dt)")
                            
                            let seconds = TimeZone.current.secondsFromGMT()
                            print("@@@ seconds \(seconds)")
                            let adjusted = Date(timeIntervalSince1970: dt.timeIntervalSince1970+Double(seconds))
                            print("@@@ ADJUSTED DATE \(adjusted.startOfDay)")
                            let adjusted2 = Date(timeIntervalSince1970: adjusted.startOfDay.timeIntervalSince1970+Double(seconds))
                            
                            detailVC.date = adjusted2
                            /*
                             let dateFormatter = DateFormatter()
                             dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Input Format
                             // dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
                             
                             dateFormatter.timeZone = TimeZone.current
                             
                             let str = dateFormatter.string(from: dt.startOfDay)
                             print("@@@ STRING DATE \(str)")
                             
                             
                             let formatter2 = DateFormatter()
                             formatter2.dateFormat = "yyyy-MM-dd HH:mm:ss"
                             formatter2.timeZone = TimeZone.current
                             // let UTCToCurrentFormat = formatter2.string(from: str)*/
                            //detailVC.date = formatter2.date(from: str)
                            
                            
                            
                            //let UTCDate = dateFormatter.date(from: str)
                            //print("@@@ UTCDate \(UTCDate)")
                            
                            /*
                             dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss" // Output Format
                             dateFormatter.timeZone = TimeZone.current
                             let UTCToCurrentFormat = dateFormatter.string(from: UTCDate!)
                             */
                            
                            /*
                             let formatter = DateFormatter()
                             // formatter.timeZone = TimeZone(abbreviation: "UTC")
                             formatter.dateFormat = "MM/dd/yyyy"
                             print("@@@ formatter.timeZone \(formatter.timeZone)")
                             let str = formatter.string(from: dt.startOfDay)
                             print("@@@ STRING DATE \(str)")
                             //formatter.timeZone = TimeZone(abbreviation: "America/Los_Angeles")
                             */
                            //detailVC.date = UTCDate
                            print("@@@ DATE DATE \(detailVC.date)")
                            detailVC.energy_unit = self.energy_unit
                            // print("1 SELECT DATE \(dt)")
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                    }
                }
                
            })
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
        
        
        
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
                self.time.text = date_formatter.string(from: timestamp.fromUTC())
                self.timeago.text = Util.timeAgoSinceDate(date: timestamp.fromUTC() as NSDate, numericDates: true)
            }
        } else {
            print("NO DATA")
            return;
        }
        
        
        if (self.savior.stype == 0) || self.savior.stype == Constants.temperature_only_stype || self.savior.stype == Constants.remote_well {
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "UTC")

        let req:CalculateHistoricalRequest = CalculateHistoricalRequest()
        req.macAddress = self.savior.savior_address!
        let modifiedDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        req.fromdate = formatter.string(from: modifiedDate)
        req.todate = formatter.string(from: Date())
        AzureApi.shared.getAdditionalData(req: req) { (error:ServerError?, response:AdditionalDataResponse?) in
            if let response = response {
                if response.items.count > 0 {
                    self.additiona_data.removeAll()
                    let header = AdditionalDataItem()
                    header.header = true
                    self.additiona_data.append(header)
                    self.additiona_data.append(contentsOf: response.items)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }

    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 4) && additiona_data.count > 0 {
            return "Additional Data"
        }
        return nil
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
       // if savior.stype == Constants.temperature_only_stype {
       //     return 3
       // }
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            if (self.savior.stype == 0) || (self.savior.stype == 1) || (self.savior.stype == 2) || (self.savior.stype == 4) || self.savior.stype == Constants.remote_well {
                return 0
            } else {
                return 1
            }
        }
        if (section == 2) && ((self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)) {
            return 0
        }
        if (section == 3) && self.savior.stype == Constants.temperature_only_stype {
            return 0
        }
        if (section == 4) {
            return additiona_data.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if (self.savior.stype == 0) || self.savior.stype == Constants.remote_well {
                print("CELL HERE 1 \(self.savior.name)")
                let cell:DetailWaterInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INFO_CELL", for: indexPath) as? DetailWaterInfoCell)!
                
                cell.savior = self.savior
                cell.populate()
                
                return cell;
            } else if self.savior.stype == Constants.water_gals2_stype || self.savior.stype == Constants.water_gals4_stype || self.savior.stype == Constants.water_gals8_stype {
                
                print("CELL HERE 2 \(self.savior.name)")
                let cell:DetailWaterFlowInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INFO_FLOW_CELL", for: indexPath) as? DetailWaterFlowInfoCell)!
                
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;

            } else if self.savior.stype == Constants.temperature_only_stype {
                let cell:DetailTempOnlyInfoCellTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_ONLY_INFO_CELL", for: indexPath) as? DetailTempOnlyInfoCellTableViewCell)!
                
                cell.savior = self.savior
                cell.populate()

                return cell;

            }
            
            print("CELL HERE 3 \(self.savior.name)")
            let cell:DetailEnergyInfoCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_INFO_CELL", for: indexPath) as? DetailEnergyInfoCell)!
            
            cell.savior = self.savior
            cell.energy_unit = self.energy_unit
            cell.populate()
            
            return cell;
        case 1:
            if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {
                let cell:EnergyPowerUsageChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_POWER_CHART", for: indexPath) as? EnergyPowerUsageChartCell)!
                
                cell.end = Date.UTCDate()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;
            }
        case 2:
            if (self.savior.stype == 0) || (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {

                let cell:WaterIntensityChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INTENSITY_CHART", for: indexPath) as? WaterIntensityChartCell)!
                
                cell.end = Date.UTCDate()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;
            } else if savior.stype == Constants.temperature_only_stype {
                let cell:TemperatureChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_CHART", for: indexPath) as? TemperatureChartCell)!
                
                cell.end = Date.UTCDate()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;
            } else if self.savior.stype == Constants.remote_well {
                let cell:RemoteWellOnOffChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "REMOTE_WELL_CHART", for: indexPath) as? RemoteWellOnOffChartCell)!
                
                cell.end = Date.UTCDate()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.populate()

                return cell;
            } else {
                let cell:EnergyPowerUsageChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_POWER_CHART", for: indexPath) as? EnergyPowerUsageChartCell)!
                
                cell.end = Date.UTCDate()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;
            }
        case 3:
            let cell:TemperatureChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_CHART", for: indexPath) as? TemperatureChartCell)!
            
            cell.end = Date.UTCDate()
            let calendar = NSCalendar.autoupdatingCurrent
            cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
            cell.savior = self.savior
            cell.energy_unit = self.energy_unit
            cell.populate()
            
            return cell;
        case 4:
            let cell:AdditionalDataCell = (self.tableView.dequeueReusableCell(withIdentifier: "ADDITIONAL_DATA_CELL", for: indexPath) as? AdditionalDataCell)!
            
            cell.item = self.additiona_data[indexPath.row]
            cell.populate()
            
            return cell;

        default:
            break
        }
        return UITableViewCell()

    }
    
}
extension Calendar {
    static let utc: Calendar  = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    static let localTime: Calendar  = {
        var calendar = Calendar.current
        calendar.timeZone = .current
        return calendar
    }()
}
extension Date {
    static func UTCDate() -> Date {
        let date = Date()
        let seconds = TimeZone.current.secondsFromGMT()
        let adjusted = Date(timeIntervalSince1970: date.timeIntervalSince1970+Double(seconds))
        return adjusted;
    }
    
    func fromUTC() -> Date {
        let seconds = TimeZone.current.secondsFromGMT()
        let adjusted = Date(timeIntervalSince1970: self.timeIntervalSince1970-Double(seconds))
        return adjusted;
    }
    
    func toUTC() -> Date {
        let seconds = TimeZone.current.secondsFromGMT()
        let adjusted = Date(timeIntervalSince1970: self.timeIntervalSince1970+Double(seconds))
        return adjusted;
    }

}
