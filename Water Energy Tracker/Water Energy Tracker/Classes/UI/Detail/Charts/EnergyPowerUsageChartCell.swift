//
//  EnergyPowerUsageChartCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class EnergyPowerUsageChartCell: UITableViewCell {
    
    @IBOutlet var chartView: BarChartView!
    @IBOutlet weak var heading: UILabel!
    
    var start:Date!
    var end:Date!
    var savior:RealmSavior!
    var energy_unit:Int = 0
    var countToDate:[Double:Double] = [:]
    var history:Bool = false

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
        
        
        var per_pulse = 0.01
        if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24) {
            heading.text = "Water Usage in last 12 hours"
            per_pulse = self.savior.EnergyUnitPerPulse
            if history {
                heading.text = "Water Usage"
            } else {
                heading.text = "Water Usage in last 12 hours"
            }
        } else {
            if history {
                heading.text = "Power Usage"
            } else {
                heading.text = "Power Usage in last 12 hours"
            }
        }
        
        
        let realm = try! Realm()
        countToDate.removeAll()
        var values:[BarChartDataEntry] = []
        print("START DATE -->\(self.start) END DATE -->\(self.end)")
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)' AND timestamp BETWEEN %@",[start,end]).sorted(byKeyPath: "timestamp", ascending: true)
        if items.count > 0 {
            var last:Double? = nil
            var count:Int = 0
            for dataPoint in items {
                
                if let last = last {
                    var diff:Double? = nil
                    switch (energy_unit) {
                    case 1:
                        diff = (Double(dataPoint.C1) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C1) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C1) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 2:
                        diff = (Double(dataPoint.C2) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C2) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C2) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 3:
                        diff = (Double(dataPoint.C3) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C3) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C3) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 4:
                        diff = (Double(dataPoint.C4) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C4) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C4) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 5:
                        diff = (Double(dataPoint.C5) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C5) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C5) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 6:
                        diff = (Double(dataPoint.C6) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C6) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C6) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 7:
                        diff = (Double(dataPoint.C7) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C7) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C7) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                    case 8:
                        diff = (Double(dataPoint.C8) * per_pulse) - last;
                        if (diff! < 0.0) {
                            if (Double(dataPoint.C8) < abs(diff!) * 0.1) {
                                diff = Double(dataPoint.C8) * per_pulse;
                            } else {
                                diff = 0.0;
                            }
                        }
                        break;
                        
                    default:
                        break
                    }
                    
                    print("Y value=\(diff!)")
                    
                    countToDate[Double(count)] = dataPoint.timestamp!.timeIntervalSince1970
                    
                    let entry:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Double(round(1000*diff!)/1000)  )
                    //let entry:BarChartDataEntry = BarChartDataEntry(x: dataPoint.timestamp!.timeIntervalSince1970-400.0-(86400.0*365.0*47.0), y: Double(round(1000*diff!)/1000)  )
                    
                    //                    let entry:BarChartDataEntry = BarChartDataEntry(x: Double(round(1000*diff!)/1000), y: dataPoint.timestamp!.timeIntervalSince1970  )
                    //let entry:BarChartDataEntry = BarChartDataEntry(x: 35, y: Double(round(1000*diff!)/1000)  )
                    values.append(entry)
                }
                
                switch (energy_unit) {
                case 1:
                    last = Double(dataPoint.C1) * per_pulse;
                case 2:
                    last = Double(dataPoint.C2) * per_pulse;
                case 3:
                    last = Double(dataPoint.C3) * per_pulse;
                case 4:
                    last = Double(dataPoint.C4) * per_pulse;
                case 5:
                    last = Double(dataPoint.C5) * per_pulse;
                case 6:
                    last = Double(dataPoint.C6) * per_pulse;
                case 7:
                    last = Double(dataPoint.C7) * per_pulse;
                case 8:
                    last = Double(dataPoint.C8) * per_pulse;
                default:
                    break
                }
                count += 1
            }
            
            
        }
        
        print("VALUES \(values)")
        
        var label = "Power Usage"
        if (self.savior.stype == 20) || (self.savior.stype == 21) || (self.savior.stype == 22) || (self.savior.stype == 24) {
            label = "Water Usage"
        }
        let set1: BarChartDataSet = BarChartDataSet(values: values, label: label)
        set1.colors = [UIColor.init(hex: "#006400")]
        set1.drawValuesEnabled = false
        set1.highlightEnabled = false
        
        let data = BarChartData(dataSets: [set1])
        data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
        // data.barWidth = 0.9
        chartView.data = data
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .top
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.labelRotationAngle = -60
        let formatter = HourValueFormatter()
        formatter.countToDate = self.countToDate
        xAxis.valueFormatter = formatter
        chartView.setNeedsDisplay()
        chartView.chartDescription?.enabled = false
        chartView.fitBars = true
    }
    
    
    
}
