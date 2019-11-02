//
//  WaterIntensityChartCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class WaterIntensityChartCell: UITableViewCell {

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
        let realm = try! Realm()
        countToDate.removeAll()
        var values:[BarChartDataEntry] = []
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)' AND timestamp BETWEEN %@",[start,end]).sorted(byKeyPath: "timestamp", ascending: true)
        if items.count > 0 {
            var count:Int = 0
            for dataPoint in items {
                
                countToDate[Double(count)] = dataPoint.timestamp!.timeIntervalSince1970

                let entry:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Double(round(1000*dataPoint.HS2)/1000)  )

                values.append(entry)

                count += 1
            }
            
            
        }
        if history {
            heading.text = "Activity"
        } else {
            heading.text = "Activity in past 12 hours"
        }
        
        print("2VALUES \(values)")
        if values.count > 0 {
            
            let set1: BarChartDataSet = BarChartDataSet(values: values, label: "Activity")
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
    

}
