//
//  HistoryVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/15/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit

class HistoryVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {

    var savior: RealmSavior!
    var date:Date!
    var energy_unit:Int = 0
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var week: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var header: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(EnergyPowerUsageChartCell.self, forCellReuseIdentifier: "ENERGY_POWER_CHART")
        self.tableView.register(UINib(nibName: "EnergyPowerUsageChartCell", bundle: nil), forCellReuseIdentifier: "ENERGY_POWER_CHART")
        
        self.tableView.register(WaterIntensityChartCell.self, forCellReuseIdentifier: "WATER_INTENSITY_CHART")
        self.tableView.register(UINib(nibName: "WaterIntensityChartCell", bundle: nil), forCellReuseIdentifier: "WATER_INTENSITY_CHART")
        
        self.tableView.register(TemperatureChartCell.self, forCellReuseIdentifier: "TEMP_CHART")
        self.tableView.register(UINib(nibName: "TemperatureChartCell", bundle: nil), forCellReuseIdentifier: "TEMP_CHART")
        
        self.tableView.tableFooterView = UIView()
        if (self.savior.stype != 0) {
            self.tableView.tableHeaderView = self.header
        }
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        
        let date_formatter = DateFormatter()
        date_formatter.dateFormat = "MM/dd/yyyy"
        self.title = "\(savior.alias!) -- \(date_formatter.string(from: date))"
        
        self.populate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        

    }
    
    func populate() {
        if (self.savior.stype != 0) {
            self.day.text = ""
            self.week.text = ""
            self.month.text = ""
            self.year.text = ""

            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy-MM-dd"
            let genreq:HistoricalKwhRequest = HistoricalKwhRequest()
            genreq.mac = savior.savior_address!
            genreq.xdate = date_formatter.string(from: date)
            AzureApi.shared.getKwhHistorical(req: genreq, completionHandler: { (error:ServerError?, response:KwhResponse?) in
                if let error = error {
                    print(error)
                } else {
                    if let response = response {
                        let daily = response.Daily!.components(separatedBy: ",")
                        let weekly = response.Weekly!.components(separatedBy: ",")
                        let monthly = response.Monthly!.components(separatedBy: ",")
                        let yearly = response.Yearly!.components(separatedBy: ",")
                        
                        DispatchQueue.main.async {
                            if self.savior.stype == 20 || self.savior.stype == 21 || self.savior.stype == 22 || self.savior.stype == 24 {
                                self.day.text = Util.galToReadable(gal: Double(daily[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.week.text = Util.galToReadable(gal: Double(weekly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.month.text = Util.galToReadable(gal: Double(monthly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.year.text = Util.galToReadable(gal: Double(yearly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                            } else {
                                self.day.text = Util.kwToReadable(kw: Double(daily[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.week.text = Util.kwToReadable(kw: Double(weekly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.month.text = Util.kwToReadable(kw: Double(monthly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                                self.year.text = Util.kwToReadable(kw: Double(yearly[self.energy_unit-1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior)
                            }
                        }
                        
                    }
                }
            })
            
        }

    }

    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if (self.savior.stype == 0) || (self.savior.stype == 1) || (self.savior.stype == 2) || (self.savior.stype == 4)  {
                return 0
            } else {
                return 1
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {
                let cell:EnergyPowerUsageChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_POWER_CHART", for: indexPath) as? EnergyPowerUsageChartCell)!
                
                cell.end = Date()
                let calendar = NSCalendar.autoupdatingCurrent
                cell.start = calendar.date(byAdding:.hour, value: -12, to: cell.end)
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.populate()
                
                return cell;
            }
        case 1:
            if (self.savior.stype == 0) || (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {

                let cell:WaterIntensityChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "WATER_INTENSITY_CHART", for: indexPath) as? WaterIntensityChartCell)!
                
                cell.end = self.date.endOfDay!
                cell.start = self.date.startOfDay
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.heading.text = "Water Intensity"
                cell.populate()
                
                return cell;
                
            } else {
                let cell:EnergyPowerUsageChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "ENERGY_POWER_CHART", for: indexPath) as? EnergyPowerUsageChartCell)!
                
                cell.end = self.date.endOfDay!
                cell.start = self.date.startOfDay
                cell.savior = self.savior
                cell.energy_unit = self.energy_unit
                cell.heading.text = "Power Usage"
                cell.populate()
                
                return cell;
                
            }
        case 2:
            let cell:TemperatureChartCell = (self.tableView.dequeueReusableCell(withIdentifier: "TEMP_CHART", for: indexPath) as? TemperatureChartCell)!
            
            cell.end = self.date.endOfDay!
            cell.start = self.date.startOfDay
            cell.savior = self.savior
            cell.energy_unit = self.energy_unit
            cell.heading.text = "Temperatures"
            cell.populate()
            
            return cell;
        default:
            break
        }
        return UITableViewCell()
        
    }
}
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
