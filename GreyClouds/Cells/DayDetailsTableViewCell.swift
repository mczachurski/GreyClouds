//
//  DayDetailsTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 28.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class DayDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var highTemperatureLabelOutlet: UILabel!
    @IBOutlet weak var summaryLabelOutlet: UILabel!
    @IBOutlet weak var sunriseLabelOutlet: UILabel!
    @IBOutlet weak var sunsetLabelOutlet: UILabel!
    @IBOutlet weak var pressureLabelOutlet: UILabel!
    @IBOutlet weak var precipProbabilityLabelOutlet: UILabel!
    @IBOutlet weak var windSpeedLabelOutlet: UILabel!
    @IBOutlet weak var humidityLabelOutlet: UILabel!
    @IBOutlet weak var lowTemperatureLabelOutlet: UILabel!

    public var forecastForDay: DataPoint? {
        didSet {

            guard let forecast = self.forecastForDay else {
                return
            }

            self.imageOutlet.image = UIImage(named: forecast.icon?.rawValue ?? "clear-day")
            self.highTemperatureLabelOutlet.text = forecast.temperatureHigh?.toTemperature()
            self.lowTemperatureLabelOutlet.text = forecast.temperatureLow?.toTemperature()
            self.summaryLabelOutlet.text = forecast.summary

            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateStyle = .short
            formatter.timeStyle = .short

            if let sunriseTime = forecast.sunriseTime {
                self.sunriseLabelOutlet.text = formatter.string(from: sunriseTime)
            }

            if let sunsetTime = forecast.sunsetTime {
                self.sunsetLabelOutlet.text = formatter.string(from: sunsetTime)
            }

            let pressure = Int(forecast.pressure ?? 0)
            pressureLabelOutlet.text = "\(pressure) hPa"

            let precipitationProbability = Int((forecast.precipitationProbability ?? 0) * 100)
            precipProbabilityLabelOutlet.text = "\(precipitationProbability) %"

            let windSpeed = Int(forecast.windSpeed ?? 0)
            windSpeedLabelOutlet.text = "\(windSpeed) kph"

            let humidity = Int((forecast.humidity ?? 0) * 100)
            humidityLabelOutlet.text = "\(humidity) %"
        }
    }
}
