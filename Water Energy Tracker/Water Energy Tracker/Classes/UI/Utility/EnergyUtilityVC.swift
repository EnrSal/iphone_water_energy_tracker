//
//  EnergyUtilityVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/15/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import DatePickerDialog

class EnergyUtilityVC: SaviorVC, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    var savior: RealmSavior!
    var energy_unit:Int = 0
    
    var from:Date? = nil
    var to:Date? = nil
    @IBOutlet weak var tableView: UITableView!

    var point_lists:[[GraphPoint]] = Array(repeating: [GraphPoint](), count: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        result.text = ""
        fromdate.text = ""
        todate.text = ""
        self.title = "Energy Utility"

        self.tableView.register(EnergyHistoricalGraphCell.self, forCellReuseIdentifier: "HISTORICAL_GRAPH")
        self.tableView.register(UINib(nibName: "EnergyHistoricalGraphCell", bundle: nil), forCellReuseIdentifier: "HISTORICAL_GRAPH")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.separatorStyle = .none
        self.tableView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.point_lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EnergyHistoricalGraphCell = (self.tableView.dequeueReusableCell(withIdentifier: "HISTORICAL_GRAPH", for: indexPath) as? EnergyHistoricalGraphCell)!
        
        cell.points = self.point_lists[indexPath.row]
        cell.populate()
        
        return cell
    }

    // MARK: - Actions
    
    @IBAction func clickFrom(_ sender: Any) {
        DatePickerDialog().show("Select From Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.from = dt.startOfDay
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.fromdate.text = formatter.string(from: dt.startOfDay)
            }
        }

    }
    @IBAction func clickTo(_ sender: Any) {
        DatePickerDialog().show("Select To Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                self.to = dt.startOfDay
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                self.todate.text = formatter.string(from: dt.startOfDay)
            }
        }
    }
    @IBAction func clickCalculate(_ sender: Any) {
        if let from = self.from, let to = self.to {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/yyyy"

            let req:CalculateHistoricalRequest = CalculateHistoricalRequest()
            req.mac = self.savior.savior_address!
            req.fromdate = formatter.string(from: from)
            req.todate = formatter.string(from: to)
            req.option = "List"
            self.showHud()
            AzureApi.shared.getHistoricalGraph(req: req) { (error:ServerError?, responseList:[CalculateHistoricalResponse]?) in
                self.hideHud()
                if let error = error {
                    print(error)
                } else {
                    if let responseList = responseList {
                        let response = responseList[1]
                        let results = response.TotalKWH!.components(separatedBy: ",")
                        var str:String = ""
                        
                        
                        if (self.savior.stype == 0) || (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24)  {
                            
                            str = "\(str)\(self.savior.energy_unit_name_1!): \(Util.galToReadable(gal: Double(results[0].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            str = "\(str)\(self.savior.energy_unit_name_2!): \(Util.galToReadable(gal: Double(results[1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            if self.savior.stype == 2 || self.savior.stype == 4 {
                                str = "\(str)\(self.savior.energy_unit_name_3!): \(Util.galToReadable(gal: Double(results[2].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_4!): \(Util.galToReadable(gal: Double(results[3].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            }
                            if self.savior.stype == 4 {
                                str = "\(str)\(self.savior.energy_unit_name_5!): \(Util.galToReadable(gal: Double(results[4].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_6!): \(Util.galToReadable(gal: Double(results[5].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_7!): \(Util.galToReadable(gal: Double(results[6].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_8!): \(Util.galToReadable(gal: Double(results[7].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            }

                        } else {
                            
                            str = "\(str)\(self.savior.energy_unit_name_1!): \(Util.kwToReadable(kw: Double(results[0].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            str = "\(str)\(self.savior.energy_unit_name_2!): \(Util.kwToReadable(kw: Double(results[1].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            if self.savior.stype == 2 || self.savior.stype == 4 {
                                str = "\(str)\(self.savior.energy_unit_name_3!): \(Util.kwToReadable(kw: Double(results[2].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_4!): \(Util.kwToReadable(kw: Double(results[3].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            }
                            if self.savior.stype == 4 {
                                str = "\(str)\(self.savior.energy_unit_name_5!): \(Util.kwToReadable(kw: Double(results[4].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_6!): \(Util.kwToReadable(kw: Double(results[5].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_7!): \(Util.kwToReadable(kw: Double(results[6].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                                str = "\(str)\(self.savior.energy_unit_name_8!): \(Util.kwToReadable(kw: Double(results[7].trimmingCharacters(in: .whitespacesAndNewlines))!, savior: self.savior))\n"
                            }
                        }
                        DispatchQueue.main.async {
                            self.result.text = str
                        }
                        
                        // graph
                        let formatter2 = DateFormatter()
                        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        formatter2.timeZone = TimeZone(abbreviation: "UTC")
                        var per_pulse = 0.01
                        per_pulse = self.savior.EnergyUnitPerPulse
                        print("per_pulse \(self.savior.EnergyUnitPerPulse)")

                        let graphresponse = responseList[0]
                        for item in graphresponse.AllKWH {
                            
                            let str = item.StorageDate!.components(separatedBy: ".")[0]

                            print("item \(str) \(item.C1)")
                            let date = formatter2.date(from: str)!
                            
                            self.point_lists[0].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C1!)*per_pulse))
                            self.point_lists[1].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C2!)*per_pulse))
                            self.point_lists[2].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C3!)*per_pulse))
                            self.point_lists[3].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C4!)*per_pulse))
                            self.point_lists[4].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C5!)*per_pulse))
                            self.point_lists[5].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C6!)*per_pulse))
                            self.point_lists[6].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C7!)*per_pulse))
                            self.point_lists[7].append(GraphPoint(from: date.timeIntervalSince1970, value: Double(item.C8!)*per_pulse))
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                        }
                    }
                }
            }

        } else {
            self.showError(message: "Please select dates.")
        }
    }

}
