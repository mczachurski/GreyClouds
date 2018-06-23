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

    // MARK: - Public properties.

    public var place: Place?
    public var forecastForDay: DataPoint?

    // MARK: - Private properties.
    
    @IBOutlet private weak var iconImageOutlet: UIImageView!
    @IBOutlet private weak var dayNameLabelOutlet: UILabel!
    @IBOutlet private weak var temperatureLabelOutlet: UILabel!
    @IBOutlet private weak var dayDateLabelOutlet: UILabel!

    // MARK: - Reload view cell.

    public func reloadView() {
        guard let forecast = self.forecastForDay else {
            return
        }

        guard let timeZoneIdentifier = place?.timeZoneIdentifier,
            let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
                return
        }

        iconImageOutlet.image = Image.image(forName: forecast.icon?.rawValue ?? "clear-day")
        temperatureLabelOutlet.text = forecast.temperatureHigh?.toTemperature()

        let formatter = DateFormatter(timeZone: timeZone)
        let dayName = formatter.getDayName(from: forecast.time)
        
        dayNameLabelOutlet.text = dayName.capitalized
        dayDateLabelOutlet.text = formatter.getShortDate(from: forecast.time)
    }
}
