//
//  TemperatureChartCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 5/13/18.
//  Copyright © 2018 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class TemperatureChartCell: UITableViewCell {

    @IBOutlet var chartView: LineChartView!
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
        var values_1:[BarChartDataEntry] = []
        var values_2:[BarChartDataEntry] = []
        let items = realm.objects(RealmDataPoint.self).filter("mac = '\(savior.savior_address!)' AND timestamp BETWEEN %@",[start,end]).sorted(byKeyPath: "timestamp", ascending: true)
        if items.count > 0 {
            var count:Int = 0
            for dataPoint in items {
                
                countToDate[Double(count)] = dataPoint.timestamp!.timeIntervalSince1970
                
                let entry1:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Util.celsiusToFahrenheit(celsius: dataPoint.Temperature)  )
                let entry2:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Util.celsiusToFahrenheit(celsius: dataPoint.Temp2)  )

                values_1.append(entry1)
                values_2.append(entry2)

                count += 1
            }
            
            
        }
        
        if history {
            heading.text = "Temperature"
        } else {
            heading.text = "Temperature in last 12 hours"
        }

        if values_1.count > 0 && values_2.count > 0 {
            
            let set1: LineChartDataSet = LineChartDataSet(values: values_1, label: "Temp 1")
            set1.colors = [UIColor.init(hex: "#CC0000")]
            set1.circleColors = [UIColor.init(hex: "#CC0000")]
            set1.drawValuesEnabled = false
            set1.highlightEnabled = false
            
            let set2: LineChartDataSet = LineChartDataSet(values: values_2, label: "Temp 2")
            set2.colors = [UIColor.init(hex: "#0000CC")]
            set2.circleColors = [UIColor.init(hex: "#0000CC")]
            set2.drawValuesEnabled = false
            set2.highlightEnabled = false
            
            let data = LineChartData(dataSets: [set1, set2])
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
        }
    }

}
