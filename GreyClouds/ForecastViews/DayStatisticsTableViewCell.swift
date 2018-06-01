//
//  DayStatisticsTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 01.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class DayStatisticsTableViewCell: UITableViewCell {

    @IBOutlet private weak var pressureLabelOutlet: UILabel!
    @IBOutlet private weak var precipProbabilityLabelOutlet: UILabel!
    @IBOutlet private weak var windSpeedLabelOutlet: UILabel!
    @IBOutlet private weak var humidityLabelOutlet: UILabel!
    @IBOutlet private weak var uvIndexLabelOutlet: UILabel!
    @IBOutlet private weak var visibilityLabelOutlet: UILabel!

    public var forecastForDay: DataPoint? {
        didSet {

            guard let forecast = self.forecastForDay else {
                return
            }

            let pressure = Int(forecast.pressure ?? 0)
            self.pressureLabelOutlet.text = "\(pressure) hPa"

            let precipitationProbability = Int((forecast.precipitationProbability ?? 0) * 100)
            self.precipProbabilityLabelOutlet.text = "\(precipitationProbability) %"

            let windSpeed = Int(forecast.windSpeed ?? 0)
            self.windSpeedLabelOutlet.text = "\(windSpeed) kmph"

            let humidity = Int((forecast.humidity ?? 0) * 100)
            self.humidityLabelOutlet.text = "\(humidity) %"

            let uvIndex = Int(forecast.uvIndex ?? 0)
            self.uvIndexLabelOutlet.text = "\(uvIndex)"

            let visibility = Int(forecast.visibility ?? 0)
            self.visibilityLabelOutlet.text = "\(visibility) km"
        }
    }
}
