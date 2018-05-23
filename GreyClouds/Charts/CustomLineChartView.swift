//
//  CustomLineChartView.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 17.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import Charts

class CustomLineChartView: LineChartView {

    private(set) var values: [ChartDataEntry] = []

    init(frame: CGRect, values: [ChartDataEntry]) {
        super.init(frame: frame)

        self.values = values

        self.setCustomChartStyle()
        self.setNoDataText(title: "Loading...")
        self.renderChartViewData()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func renderChartViewData() {

        let lineChartDataSet = self.createLineChartDataSet()
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        self.data = lineChartData
    }

    private func createLineChartDataSet() -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(values: self.values, label: "DataSet 1")
         lineChartDataSet.drawIconsEnabled = false
         lineChartDataSet.highlightLineDashLengths = [5, 2.5]
        lineChartDataSet.setColor(UIColor.main)
        lineChartDataSet.setCircleColor(UIColor.main)
        lineChartDataSet.lineWidth = 3
        lineChartDataSet.circleRadius = 3
        // lineChartDataSet.drawCircleHoleEnabled = false
         lineChartDataSet.valueFont = .systemFont(ofSize: 9)
        lineChartDataSet.formLineDashLengths = [5, 2.5]
        lineChartDataSet.formLineWidth = 1
        lineChartDataSet.formLineWidth = 15
        lineChartDataSet.drawValuesEnabled = false
        // lineChartDataSet.drawCirclesEnabled = false


         let gradientColors = [UIColor.main(alpha: 0.0).cgColor, UIColor.main(alpha: 0.3).cgColor]
         let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

         lineChartDataSet.fillAlpha = 1
         lineChartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
         lineChartDataSet.drawFilledEnabled = true

        lineChartDataSet.mode = .cubicBezier

        return lineChartDataSet
    }

    private func setNoDataText(title: String) {
        self.noDataText = title
        self.noDataTextColor = .gray
        self.notifyDataSetChanged()
    }

    private func setCustomChartStyle() {
        self.legend.enabled = false
        self.drawBordersEnabled = false
        self.xAxis.enabled = true
        self.xAxis.drawAxisLineEnabled = false
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.labelPosition = XAxis.LabelPosition.bottom
        // self.leftAxis.enabled = false
        self.rightAxis.enabled = false
        self.dragEnabled = false
        self.pinchZoomEnabled = false
        self.scaleXEnabled = false
        self.scaleYEnabled = false
        self.chartDescription?.text = ""
        self.animate(yAxisDuration: 0.75)

        // self.backgroundColor = .red

    }
}
