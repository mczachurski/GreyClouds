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

    // MARK: - Public properties.

    public var forecastForDay: DataPoint?

    // MARK: - Private properties.

    @IBOutlet private weak var pressureLabelOutlet: UILabel!
    @IBOutlet private weak var precipProbabilityLabelOutlet: UILabel!
    @IBOutlet private weak var windSpeedLabelOutlet: UILabel!
    @IBOutlet private weak var humidityLabelOutlet: UILabel!
    @IBOutlet private weak var uvIndexLabelOutlet: UILabel!
    @IBOutlet private weak var visibilityLabelOutlet: UILabel!

    // MARK: - Reload view cell.

    public func reloadView() {
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

        if let visibility = forecast.visibility {
            self.visibilityLabelOutlet.text = "\(Int(visibility)) km"
        } else {
            self.visibilityLabelOutlet.text = "- km"
        }
    }
}
