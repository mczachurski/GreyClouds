//
//  WeatherItemTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 26.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class WeatherItemTableViewCell: UITableViewCell {

    @IBOutlet private weak var iconImageOutlet: UIImageView!
    @IBOutlet private weak var dayNameLabelOutlet: UILabel!
    @IBOutlet private weak var temperatureLabelOutlet: UILabel!
    @IBOutlet private weak var dayDateLabelOutlet: UILabel!

    public var place: Place?
    public var forecastForDay: DataPoint?

    public func reloadView() {
        guard let forecast = self.forecastForDay else {
            return
        }

        guard let timeZoneIdentifier = place?.timeZoneIdentifier,
            let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
                return
        }

        iconImageOutlet.image = UIImage.init(named: forecast.icon?.rawValue ?? "clear-day")
        temperatureLabelOutlet.text = forecast.temperatureHigh?.toTemperature()

        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = timeZone

        formatter.dateFormat = "EEEE"
        let dayName = formatter.string(from: forecast.time)
        dayNameLabelOutlet.text = dayName.capitalized

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dayDateLabelOutlet.text = formatter.string(from: forecast.time)
    }
}
