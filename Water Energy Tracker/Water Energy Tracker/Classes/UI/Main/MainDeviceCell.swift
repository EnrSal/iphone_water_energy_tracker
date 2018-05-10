//
//  MainDeviceCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/8/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class MainDeviceCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var savior: RealmSavior!
    
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var solminutes: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var signalImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var unit1_usage:String? = nil
    var unit2_usage:String? = nil
    var unit3_usage:String? = nil
    var unit4_usage:String? = nil
    var unit5_usage:String? = nil
    var unit6_usage:String? = nil
    var unit7_usage:String? = nil
    var unit8_usage:String? = nil

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.register(DeviceNameSubCell.self, forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        self.tableView.register(UINib(nibName: "DeviceNameSubCell", bundle: nil), forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populate() {
        self.name.text = savior.alias!
        unit1_usage = nil
        unit2_usage = nil
        unit3_usage = nil
        unit4_usage = nil
        unit5_usage = nil
        unit6_usage = nil
        unit7_usage = nil
        unit8_usage = nil

        self.solminutes.text = "Not synced"
        self.solminutes.textColor = UIColor.lightGray

        //title.setText(device.getName());
        self.setDetails()

        if self.savior.stype == 0 {
            self.typeImage.image = #imageLiteral(resourceName: "ic_water")
        } else {
            self.typeImage.image = #imageLiteral(resourceName: "ic_energy")
        }

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMddyyyyHH:mm:ss"
        
        let datestr = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        
        let genreq:GenericRequest = GenericRequest()
        genreq.name = savior.savior_address!
        AzureApi.shared.getKwh(req: genreq) { (error:ServerError?, response:KwhResponse?) in
            if let error = error {
                print(error)
            } else {
                if let response = response {
                    let values = response.Daily!.components(separatedBy: ",")
                    self.unit1_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit2_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit3_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit4_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit5_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit6_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit7_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    self.unit8_usage = "\(String(format: "%.2f", Float(values[0])!)) \(self.savior.EnergyUnit!)"
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
        }
        
        
        let req:GetDataRequest = GetDataRequest()
        req.mac = savior.savior_address!
        req.stype = savior.stype
        req.utct = datestr
        
        self.spinner.startAnimating()
        AzureApi.shared.getData(req: req, completionHandler: { (error:ServerError?, response:GetDataResponse?) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            } else {
                if let response = response {
                    
                    let realm = try! Realm()
                    try! realm.write {
                        self.savior.last_sync = Date()
                        for device in response.Result {
                            
                            let dataPoint:RealmDataPoint = RealmDataPoint(fromDataPoint: device)
                            let current = realm.objects(RealmDataPoint.self).filter("identifier = '\(dataPoint.identifier!)'").first
                            if current == nil {
                                realm.add(dataPoint)
                                print("ADDED \(dataPoint)")
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.spinner.stopAnimating()
                        self.setDetails()
                    }
                }
            }
            
        })
        
        
        
    }
    
    func setDetails() {
        let realm = try! Realm()
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
        if items.count > 0 {
            let current = items.first
            let num = current!.SignalStrength
            if num > -60 {
                signalImage.image = #imageLiteral(resourceName: "four")
            } else if ((num <= -60) && (num > -80)) {
                signalImage.image = #imageLiteral(resourceName: "three")
            } else if ((num <= -80) && (num > -90)) {
                signalImage.image = #imageLiteral(resourceName: "two")
            } else {
                signalImage.image = #imageLiteral(resourceName: "one")
            }
            
            if let last_sync = savior.last_sync {
                self.solminutes.text = Util.timeAgoSinceDate(date: last_sync as NSDate, numericDates: true)
            }
            
            if !savior.isValidDevice() {
                self.solminutes.text = "Not valid or expired"
                self.solminutes.textColor = UIColor.red
            }
         

        }
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        switch savior.stype {
        case 0:
            return 0
        case 1:
            return 2
        case 2:
            return 4
        case 4:
            return 8
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeviceNameSubCell = (self.tableView.dequeueReusableCell(withIdentifier: "DEVICE_NAME_SUBCELL", for: indexPath) as? DeviceNameSubCell)!
        
        switch indexPath.row {
        case 0:
            if let energy_unit_name_1 = self.savior.energy_unit_name_1 {
                cell.name.text = energy_unit_name_1
            } else {
                cell.name.text = "unit 1"
            }
            if let unit1_usage = self.unit1_usage {
                cell.info.text = unit1_usage
            } else {
                cell.info.text = ""
            }
        case 1:
            if let energy_unit_name_2 = self.savior.energy_unit_name_2 {
                cell.name.text = energy_unit_name_2
            } else {
                cell.name.text = "unit 2"
            }
            if let unit2_usage = self.unit2_usage {
                cell.info.text = unit2_usage
            } else {
                cell.info.text = ""
            }
        case 2:
            if let energy_unit_name_3 = self.savior.energy_unit_name_3 {
                cell.name.text = energy_unit_name_3
            } else {
                cell.name.text = "unit 3"
            }
            if let unit3_usage = self.unit3_usage {
                cell.info.text = unit3_usage
            } else {
                cell.info.text = ""
            }
        case 3:
            if let energy_unit_name_4 = self.savior.energy_unit_name_4 {
                cell.name.text = energy_unit_name_4
            } else {
                cell.name.text = "unit 4"
            }
            if let unit4_usage = self.unit4_usage {
                cell.info.text = unit4_usage
            } else {
                cell.info.text = ""
            }
        case 4:
            if let energy_unit_name_5 = self.savior.energy_unit_name_5 {
                cell.name.text = energy_unit_name_5
            } else {
                cell.name.text = "unit 5"
            }
            if let unit5_usage = self.unit5_usage {
                cell.info.text = unit5_usage
            } else {
                cell.info.text = ""
            }
        case 5:
            if let energy_unit_name_6 = self.savior.energy_unit_name_6 {
                cell.name.text = energy_unit_name_6
            } else {
                cell.name.text = "unit 6"
            }
            if let unit6_usage = self.unit6_usage {
                cell.info.text = unit6_usage
            } else {
                cell.info.text = ""
            }
        case 6:
            if let energy_unit_name_7 = self.savior.energy_unit_name_7 {
                cell.name.text = energy_unit_name_7
            } else {
                cell.name.text = "unit 7"
            }
            if let unit7_usage = self.unit7_usage {
                cell.info.text = unit7_usage
            } else {
                cell.info.text = ""
            }
        case 7:
            if let energy_unit_name_8 = self.savior.energy_unit_name_8 {
                cell.name.text = energy_unit_name_8
            } else {
                cell.name.text = "unit 8"
            }
            if let unit8_usage = self.unit8_usage {
                cell.info.text = unit8_usage
            } else {
                cell.info.text = ""
            }
        default:
            break
        }
        
        
        return cell;
    }

}
