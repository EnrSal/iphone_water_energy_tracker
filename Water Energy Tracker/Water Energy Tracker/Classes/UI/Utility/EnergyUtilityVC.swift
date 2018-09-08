//
//  EnergyUtilityVC.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/15/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import DatePickerDialog

class EnergyUtilityVC: SaviorVC {

    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var todate: UILabel!
    @IBOutlet weak var fromdate: UILabel!
    var savior: RealmSavior!
    var energy_unit:Int = 0
    
    var from:Date? = nil
    var to:Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        result.text = ""
        fromdate.text = ""
        todate.text = ""
        self.title = "Energy Utility"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

            self.showHud()
            AzureApi.shared.calculateHistorical(req: req, completionHandler: { (error:ServerError?, response:CalculateHistoricalResponse?) in
                self.hideHud()
                if let error = error {
                    print(error)
                } else {
                    if let response = response {
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
                    }
                }
            })

        } else {
            self.showError(message: "Please select dates.")
        }
    }

}
