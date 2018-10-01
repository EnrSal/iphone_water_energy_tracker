//
//  DetailEnergyInfoCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/10/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import RealmSwift

class DetailEnergyInfoCell: UITableViewCell {
    
    @IBOutlet weak var temp2: UILabel!
    @IBOutlet weak var temp1: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var week: UILabel!
    var savior: RealmSavior!
    var energy_unit:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populate() {
        
        let realm = try! Realm()
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)'").sorted(byKeyPath: "timestamp", ascending: false)
        if items.count > 0 {
            let current = items.first
            
            if self.savior.stype == 20 || self.savior.stype == 21 || self.savior.stype == 22 || self.savior.stype == 24 {
                switch self.energy_unit {
                case 1:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C1, savior: self.savior)
                case 2:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C2, savior: self.savior)
                case 3:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C3, savior: self.savior)
                case 4:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C4, savior: self.savior)
                case 5:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C5, savior: self.savior)
                case 6:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C6, savior: self.savior)
                case 7:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C7, savior: self.savior)
                case 8:
                    info.text = Util.waterPulsesToReadableThreeDec(pulses: current!.C8, savior: self.savior)
                default:
                    break
                }
            } else {
                
                switch self.energy_unit {
                case 1:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C1, savior: self.savior)
                case 2:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C2, savior: self.savior)
                case 3:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C3, savior: self.savior)
                case 4:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C4, savior: self.savior)
                case 5:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C5, savior: self.savior)
                case 6:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C6, savior: self.savior)
                case 7:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C7, savior: self.savior)
                case 8:
                    info.text = Util.totalpulsesToReadableThreeDec(pulses: current!.C8, savior: self.savior)
                default:
                    break
                }
            }
            self.temp1.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temperature))) °F"
            self.temp2.text = "\(String(format: "%.1f", Util.celsiusToFahrenheit(celsius: current!.Temp2))) °F"
        }
        
        let genreq:GenericRequest = GenericRequest()
        genreq.name = savior.savior_address!
        AzureApi.shared.getKwh(req: genreq) { (error:ServerError?, response:KwhResponse?) in
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
        }
        
    }
    
    
}
