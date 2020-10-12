//
//  RemoteWellOnOffChartCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 10/11/20.
//  Copyright © 2020 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class RemoteWellOnOffChartCell: UITableViewCell {

    @IBOutlet var chartView: BarChartView!
    @IBOutlet weak var heading: UILabel!
    var savior:RealmSavior!
    var history:Bool = false
    var start:Date!
    var end:Date!
    var countToDate:[Double:Double] = [:]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate() {
        heading.text = "ON/OFF state in the last 12 hours"
        if history {
            heading.text = "ON/OFF state"
        }
        let realm = try! Realm()
        countToDate.removeAll()
        var values:[BarChartDataEntry] = []
        print("START DATE -->\(self.start) END DATE -->\(self.end)")
     
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)' AND timestamp BETWEEN %@",[start,end]).sorted(byKeyPath: "timestamp", ascending: true)
        print("TOTAL ITEMS -->\(items.count)")
        if items.count > 0 {
            var count = 0
            for dataPoint in items {
                
              //  print("Y value=\(diff!)")
                
                print("@@@z G DATE -->\(dataPoint.timestamp!)")
                countToDate[Double(count)] = dataPoint.timestamp!.timeIntervalSince1970
                
                let entry:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Double(dataPoint.C1))
                values.append(entry)
                
                count += 1
            }
            
            
        }
        
        print("1VALUES \(values)")
        
        let label = "On State"
        if values.count > 0 {
            let set1: BarChartDataSet = BarChartDataSet(values: values, label: label)
            set1.colors = [UIColor.init(hex: "#006400")]
            set1.drawValuesEnabled = false
            set1.highlightEnabled = false
            
            let data = BarChartData(dataSets: [set1])
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            // data.barWidth = 0.9
            chartView.data = data
            
            let yAxis = chartView.rightAxis
            yAxis.axisMaximum = 1
            yAxis.axisMinimum = 0
            yAxis.valueFormatter = OnOffFormatter()

            let yAxis2 = chartView.leftAxis
            yAxis2.axisMaximum = 1
            yAxis2.axisMinimum = 0
            yAxis2.valueFormatter = OnOffFormatter()

            
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
    
}
