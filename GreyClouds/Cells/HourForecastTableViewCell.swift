//
//  ForecastTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 28.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class HourForecastTableViewCell: UITableViewCell {

    @IBOutlet private weak var hourLabelOutlet: UILabel!
    @IBOutlet private weak var temperatureLabelOutlet: UILabel!
    @IBOutlet private weak var imageOutlet: UIImageView!
    @IBOutlet weak var precipProbabilityLabelOutlet: UILabel!
    @IBOutlet weak var precipImageOutlet: UIImageView!

    public var forecastForHour: DataPoint? {
        didSet {

            guard let forecast = self.forecastForHour else {
                return
            }

            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateStyle = .none
            formatter.timeStyle = .short
            self.hourLabelOutlet.text = formatter.string(from: forecast.time)

            self.temperatureLabelOutlet.text = forecast.temperature?.toTemperature()

            let imageName = (forecast.icon?.rawValue ?? "clear-day") + "-small"
            self.imageOutlet.image = UIImage(named: imageName)

            let precipProbabilityInteger = Int((forecast.precipitationProbability ?? 0) * 100)
            self.precipProbabilityLabelOutlet.text = "\(precipProbabilityInteger)%"

            let precipImageName = self.getPrecipImageName(precipProbabilityInteger: precipProbabilityInteger)
            self.precipImageOutlet.image = UIImage(named: precipImageName)
        }
    }

    private func getPrecipImageName(precipProbabilityInteger: Int) -> String {
        var precipImageName = "rain-0"
        switch precipProbabilityInteger {
        case 0:
            precipImageName = "rain-0"
        case 1...10:
            precipImageName = "rain-1"
        case 11...20:
            precipImageName = "rain-2"
        case 21...30:
            precipImageName = "rain-3"
        case 31...40:
            precipImageName = "rain-4"
        case 41...50:
            precipImageName = "rain-5"
        case 51...60:
            precipImageName = "rain-6"
        case 61...70:
            precipImageName = "rain-7"
        case 71...80:
            precipImageName = "rain-8"
        case 81...90:
            precipImageName = "rain-9"
        case 91...100:
            precipImageName = "rain-10"
        default:
            precipImageName = "rain-0"
        }

        return precipImageName
    }
}
