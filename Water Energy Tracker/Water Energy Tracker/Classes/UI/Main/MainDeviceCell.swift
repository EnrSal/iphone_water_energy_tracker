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
    @IBOutlet weak var numgalsWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var numgals: UILabel!
    
    var unit1_usage:String? = nil
    var unit2_usage:String? = nil
    var unit3_usage:String? = nil
    var unit4_usage:String? = nil
    var unit5_usage:String? = nil
    var unit6_usage:String? = nil
    var unit7_usage:String? = nil
    var unit8_usage:String? = nil
    
    var owner:MainVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tableView.register(DeviceNameSubCell.self, forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        self.tableView.register(UINib(nibName: "DeviceNameSubCell", bundle: nil), forCellReuseIdentifier: "DEVICE_NAME_SUBCELL")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = 44
        self.tableView.separatorStyle = .none
        
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var populating_address:String? = nil
    
    func populate() {
        populating_address = savior.savior_address!

        let req:GenericRequest = GenericRequest()
        req.name = savior.savior_address!
        print("############# GET NAMES NO CHANGE")
        self.spinner.startAnimating()
        AzureApi.shared.getNamesNoChange(req: req, completionHandler: { (error:ServerError?, response:NamesResponse?, origname:String) in
            
            if let error = error {
                self.spinner.stopAnimating()
                print("ERROR \(error)")
            } else {
                if let response = response {
                    if origname != self.populating_address! {
                        return
                    }
                    
                    let realm = try! Realm()
                    DispatchQueue.main.async {
                        try! realm.write {
                            self.savior.share_number_prev = self.savior.share_number
                            self.savior.share_number = response.ShareNumber
                            self.savior.temp_share_number_prev = self.savior.temp_share_number
                            self.savior.temp_share_number = response.TempShareNumber
                            self.savior.stype = Int(response.Stype!)!
                            self.savior.alias = response.DeviceName
                            self.savior.energy_unit_name_1 = response.Name1
                            self.savior.energy_unit_name_2 = response.Name2
                            self.savior.energy_unit_name_3 = response.Name3
                            self.savior.energy_unit_name_4 = response.Name4
                            self.savior.energy_unit_name_5 = response.Name5
                            self.savior.energy_unit_name_6 = response.Name6
                            self.savior.energy_unit_name_7 = response.Name7
                            self.savior.energy_unit_name_8 = response.Name8
                            if self.savior.alias == nil {
                                self.savior.alias = "no name"
                            }
                        }
                        self.populateImpl(orig: origname)
                    }
                    
                } else {
                    self.spinner.stopAnimating()
                }
            
            }
        })
    }
    
    func populateImpl(orig:String) {
        if orig != self.populating_address! {
            return
        }
        self.name.text = savior.alias!
        unit1_usage = nil
        unit2_usage = nil
        unit3_usage = nil
        unit4_usage = nil
        unit5_usage = nil
        unit6_usage = nil
        unit7_usage = nil
        unit8_usage = nil
        self.temp.text = ""
        self.solminutes.text = "Not synced"
        self.solminutes.textColor = UIColor.lightGray
        
        //title.setText(device.getName());
        self.setDetails()
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "MMddyyyyHH:mm:ss"
        
        
        if self.savior.stype == 20 {
            self.numgalsWidthConstraint.constant = 70
            self.numgals.isHidden = false
        } else {
            self.numgalsWidthConstraint.constant = 0
            self.numgals.isHidden = true
        }
        let datestr = formatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)
        print("STYPE = \(savior.stype) \(savior.alias!)")
        if self.savior.stype == 0 {
            self.typeImage.image = #imageLiteral(resourceName: "ic_water")
            self.typeImage.contentMode = .scaleAspectFit
            self.tableHeight.constant = 0
            
        } else if self.savior.stype == 20 || self.savior.stype == 21 || self.savior.stype == 22 || self.savior.stype == 24  {
            self.typeImage.image = #imageLiteral(resourceName: "ic_water")
            switch savior.stype {
            case 20:
                self.tableHeight.constant = 0
            case 21:
                self.tableHeight.constant = 2*44
            case 22:
                self.tableHeight.constant = 4*44
            case 24:
                self.tableHeight.constant = 8*44
            default:
                break
            }


            let genreq:GenericRequest = GenericRequest()
            genreq.name = savior.savior_address!
            AzureApi.shared.getKwh(req: genreq) { (error:ServerError?, response:KwhResponse?, origname:String) in
                if let error = error {
                    print(error)
                } else {
                    if let response = response {
                        if origname != self.populating_address! {
                            return
                        }
                        DispatchQueue.main.async {
                            let values = response.Daily!.components(separatedBy: ",")
                            print("zzVALUES \(values)")
                            let realm = try! Realm()
                            
                            if self.savior.EnergyUnit == nil {
                                print("@@@ here 1)")
                                try! realm.write {
                                    print("@@@ here 2)")
                                    self.savior.EnergyUnit = "kWh"
                                    if self.savior.EnergyUnitPerPulse == 0.0 {
                                        self.savior.EnergyUnitPerPulse = 0.1
                                    }
                                    print("@@@ here 3)")
                                }
                                print("@@@ here 4)")
                            }
                            print("@@@ here 5)")
                            
                            self.unit1_usage = "\(String(format: "%.2f", Float(values[0].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.numgals.text = "\(String(format: "%.2f", Float(values[0].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit2_usage = "\(String(format: "%.2f", Float(values[1].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit3_usage = "\(String(format: "%.2f", Float(values[2].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit4_usage = "\(String(format: "%.2f", Float(values[3].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit5_usage = "\(String(format: "%.2f", Float(values[4].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit6_usage = "\(String(format: "%.2f", Float(values[5].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit7_usage = "\(String(format: "%.2f", Float(values[6].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.unit8_usage = "\(String(format: "%.2f", Float(values[7].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }


        } else {
            DispatchQueue.main.async {
                self.typeImage.image = #imageLiteral(resourceName: "ic_energy")
                switch self.savior.stype {
                case 0:
                    self.tableHeight.constant = 0
                case 1,31:
                    self.tableHeight.constant = 2*44
                case 2,32:
                    self.tableHeight.constant = 4*44
                case 4,34:
                    self.tableHeight.constant = 8*44
                case Constants.temperature_only_stype:
                    self.tableHeight.constant = 0
                    self.typeImage.image = UIImage(named: "ic_temp")
                default:
                    break
                }
                
                self.layoutIfNeeded()
                
                print("@@@@@ TYPE \(self.savior.stype) CONSTANT \(self.tableHeight.constant)")
            }
            
            let genreq:GenericRequest = GenericRequest()
            genreq.name = savior.savior_address!
            AzureApi.shared.getKwh(req: genreq) { (error:ServerError?, response:KwhResponse?, origname:String) in
                if let error = error {
                    print(error)
                } else {
                    if let response = response {
                        if origname != self.populating_address! {
                            return
                        }
                        DispatchQueue.main.async {
                            if let daily = response.Daily {
                                let values = daily.components(separatedBy: ",")
                                print("3VALUES \(values)")
                                //let realm = try! Realm()
                                
                                
                                if self.savior.EnergyUnit == nil {
                                    let realm = try! Realm()
                                    try! realm.write {
                                        self.savior.EnergyUnit = "kWh"
                                        if self.savior.EnergyUnitPerPulse == 0.0 {
                                            self.savior.EnergyUnitPerPulse = 0.1
                                        }
                                    }
                                }
                                
                                self.unit1_usage = "\(String(format: "%.2f", Float(values[0].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit2_usage = "\(String(format: "%.2f", Float(values[1].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit3_usage = "\(String(format: "%.2f", Float(values[2].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit4_usage = "\(String(format: "%.2f", Float(values[3].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit5_usage = "\(String(format: "%.2f", Float(values[4].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit6_usage = "\(String(format: "%.2f", Float(values[5].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit7_usage = "\(String(format: "%.2f", Float(values[6].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                self.unit8_usage = "\(String(format: "%.2f", Float(values[7].trimmingCharacters(in: CharacterSet.whitespaces))!)) \(self.savior.EnergyUnit!)"
                                
                                /*
                                 self.unit1_usage = "\(String(format: "%.2f", Float(values[0].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit2_usage = "\(String(format: "%.2f", Float(values[1].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit3_usage = "\(String(format: "%.2f", Float(values[2].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit4_usage = "\(String(format: "%.2f", Float(values[3].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit5_usage = "\(String(format: "%.2f", Float(values[4].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit6_usage = "\(String(format: "%.2f", Float(values[5].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit7_usage = "\(String(format: "%.2f", Float(values[6].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                                 self.unit8_usage = "\(String(format: "%.2f", Float(values[7].trimmingCharacters(in: CharacterSet.whitespaces))! * Float(self.savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"*/
                                self.tableView.reloadData()
                            } else {
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }
            }
            
        }

        let req:GetDataRequest = GetDataRequest()
        req.mac = savior.savior_address!
        req.stype = savior.stype
        req.utct = datestr
        print("@@@ TRY GET DATA")
        AzureApi.shared.getData(req: req, completionHandler: { (error:ServerError?, response:GetDataResponse?, origname:String) in
            
            if let error = error {
                print(error)
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                }
            } else {
                if let response = response {
                    if origname != self.populating_address! {
                        return
                    }
                    DispatchQueue.main.async {
                        
                        let realm = try! Realm()
                        try! realm.write {
                            self.savior.last_sync = Date()
                            print("@@@ LAST SYNC IS -->\(self.savior.last_sync)")
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
                self.solminutes.text = Util.timeAgoSinceDate(date: current?.timestamp?.fromUTC() as! NSDate, numericDates: true)
            }
            
            if !savior.isValidDevice() {
                self.solminutes.text = "Not valid or expired"
                self.solminutes.textColor = UIColor.red
            }
            
            let tmp = (current!.Temperature + current!.Temp2) / 2.0;
            self.temp.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: tmp))) °F"
            
            
            
            /*
            
            if let current = current {
                if self.savior.stype == 21 || self.savior.stype == 22 || self.savior.stype == 24 {
                    self.unit1_usage = "\(String(format: "%.2f", Float(Double(current.C1) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                    self.unit2_usage = "\(String(format: "%.2f", Float(Double(current.C2) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"

                }
                if self.savior.stype == 22 || self.savior.stype == 24 {
                    self.unit3_usage = "\(String(format: "%.2f", Float(Double(current.C3) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                    self.unit4_usage = "\(String(format: "%.2f", Float(Double(current.C4) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                }
                if self.savior.stype == 24 {
                    self.unit5_usage = "\(String(format: "%.2f", Float(Double(current.C5) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                    self.unit6_usage = "\(String(format: "%.2f", Float(Double(current.C6) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                    self.unit7_usage = "\(String(format: "%.2f", Float(Double(current.C7) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                    self.unit8_usage = "\(String(format: "%.2f", Float(Double(current.C8) * savior.EnergyUnitPerPulse))) \(self.savior.EnergyUnit!)"
                }

            
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }*/
            
            
        } else {
            self.solminutes.text = "not synced"
        }
    }
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.savior == nil {
            return 0
        }
        
        switch savior.stype {
        case 0, 20, Constants.temperature_only_stype:
            return 0
        case 1, 21, 31:
            return 2
        case 2, 22, 32:
            return 4
        case 4, 24, 34:
            print("SUBCELLS 8 \(self.savior.name!)")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if self.savior.isValidDevice() {
            
            let realm = try! Realm()
            let items = realm.objects(RealmDataPoint.self).filter("mac = '\(self.savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
           
            print("items.count \(items.count)")

            if items.count == 0 {
                return
            }

            
            if let test_share_number_used1 = savior.share_number_used {
                print("test_share_number_used1 \(test_share_number_used1)")
                if test_share_number_used1.count == 15 {
                    
                    let index = String(test_share_number_used1.suffix(1))

                    let num = Int(index)!
                    print("test_share_number_used1 num \(num)")
                    if (num != indexPath.row+1) {
                        return
                    }
                }
            }

            
            let detailVC:DetailVC = DetailVC(nibName: "DetailVC", bundle: nil)
            detailVC.savior = self.savior
            detailVC.energy_unit = indexPath.row+1
            print("DID CLICK HERE \(indexPath.row)")
            self.owner.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}
