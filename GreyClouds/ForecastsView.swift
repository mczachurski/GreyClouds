//
//  Forecasts.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 14.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO
import Charts

class ForecastsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var temperatureViewOutlet: UIView!
    @IBOutlet weak var precipPropabilityViewOutlet: UIView!

    public var isFirstDay = false
    
    public var day: DataPoint?
    public var hourly: DataBlock? {
        didSet {
            self.createTemperatureChart()
            self.createPrecipPropabilityChart()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }

    private func commonInitialization() {
        Bundle.main.loadNibNamed("Forecasts", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func createTemperatureChart() {
        var values = [ChartDataEntry]()

        guard let hourlyData = hourly, let dayData = day else {
            return
        }

        let calendar = Calendar.current
        let forecastForDayInYear = calendar.component(.day, from: dayData.time)

        if self.isFirstDay {
            for index in 0...23 {
                let item = hourlyData.data[index]
                values.append(ChartDataEntry(x: Double(index), y: item.temperature ?? 0))
            }
        } else {
            for (index, item) in hourlyData.data.enumerated() {
                let pointForDayInYear = calendar.component(.day, from: item.time)
                if forecastForDayInYear == pointForDayInYear {
                    values.append(ChartDataEntry(x: Double(index), y: item.temperature ?? 0))
                }
            }
        }

        let chartView = CustomLineChartView(frame: temperatureViewOutlet.frame, values: values)
        self.temperatureViewOutlet.addSubview(chartView)
    }

    private func createPrecipPropabilityChart() {
        var values = [ChartDataEntry]()

        guard let hourlyData = hourly, let dayData = day else {
            return
        }

        let calendar = Calendar.current
        let forecastForDayInYear = calendar.component(.day, from: dayData.time)

        if self.isFirstDay {
            for index in 0...23 {
                let item = hourlyData.data[index]
                let precipitationProbability = (item.precipitationProbability ?? 0) * 100.0
                values.append(ChartDataEntry(x: Double(index), y: precipitationProbability))
            }
        } else {
            for (index, item) in hourlyData.data.enumerated() {
                let pointForDayInYear = calendar.component(.day, from: item.time)
                let precipitationProbability = (item.precipitationProbability ?? 0) * 100.0

                if forecastForDayInYear == pointForDayInYear {
                    values.append(ChartDataEntry(x: Double(index), y: precipitationProbability))
                }
            }
        }

        let chartView = CustomLineChartView(frame: temperatureViewOutlet.frame, values: values)
        chartView.setVisibleYRange(minYRange: 0, maxYRange: 110, axis: YAxis.AxisDependency.left)
        self.precipPropabilityViewOutlet.addSubview(chartView)
    }
}
