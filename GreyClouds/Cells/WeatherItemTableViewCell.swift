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
    @IBOutlet private  weak var dayNameLabelOutlet: UILabel!
    @IBOutlet private weak var temperatureLabelOutlet: UILabel!
    @IBOutlet weak var dayDateLabelOutlet: UILabel!
    @IBOutlet weak var windyLabelOutlet: UILabel!
    @IBOutlet weak var rainyLabelOutlet: UILabel!
    @IBOutlet weak var pressureLabelOutlet: UILabel!
    

    public var forecastForDay: DataPoint? {
        didSet {

            guard let forecast = self.forecastForDay else {
                return
            }

            iconImageOutlet.image = UIImage.init(named: forecast.icon?.rawValue ?? "clear-day")
            temperatureLabelOutlet.text = forecast.temperatureHigh?.toTemperature()

            let formatter = DateFormatter()
            formatter.locale = Locale.current

            formatter.dateFormat = "EEEE"
            dayNameLabelOutlet.text = formatter.string(from: forecast.time)

            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            dayDateLabelOutlet.text = formatter.string(from: forecast.time)

            if let windSpeed = forecast.windSpeed {
                let windSpeedInteger = Int(windSpeed)
                windyLabelOutlet.text = "\(windSpeedInteger) kph"
            }

            if let precipitationProbability = forecast.precipitationProbability {
                let precipitationProbabilityInteger = Int(precipitationProbability * 100)
                rainyLabelOutlet.text = "\(precipitationProbabilityInteger) %"
            }

            if let pressure = forecast.pressure {
                let pressureInteger = Int(pressure)
                pressureLabelOutlet.text = "\(pressureInteger) hPa"
            }
        }
    }
}
