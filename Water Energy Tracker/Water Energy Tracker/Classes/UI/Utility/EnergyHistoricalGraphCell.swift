//
//  EnergyHistoricalGraphCell.swift
//  Water Energy Tracker
//
//  Created by Boris Katok on 11/3/19.
//  Copyright © 2019 Coconut Tree Software, Inc. All rights reserved.
//

import UIKit
import Charts

class EnergyHistoricalGraphCell: UITableViewCell {

    @IBOutlet var chartView: BarChartView!
    @IBOutlet weak var heading: UILabel!
    var countToDate:[Double:Double] = [:]

    var points:[GraphPoint] = []
    
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
        countToDate.removeAll()
        var values:[BarChartDataEntry] = []
        var count = 0
        for dataPoint in points {
            countToDate[Double(count)] = dataPoint.time
            let entry:BarChartDataEntry = BarChartDataEntry(x: Double(count), y: Double(round(1000*dataPoint.value)/1000)  )
            values.append(entry)
            
            count += 1
        }
        
        if values.count > 0 {
            let label = "Power Usage"
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
            let formatter = DayValueFormatter()
            formatter.countToDate = self.countToDate
            xAxis.valueFormatter = formatter
            chartView.setNeedsDisplay()
            chartView.chartDescription?.enabled = false
            chartView.fitBars = true
        }

    }
    
}
