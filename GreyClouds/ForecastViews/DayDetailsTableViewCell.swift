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

    @IBOutlet private weak var dayNameLabelOutlet: UILabel!
    @IBOutlet private weak var imageOutlet: UIImageView!
    @IBOutlet private weak var highTemperatureLabelOutlet: UILabel!
    @IBOutlet private weak var summaryLabelOutlet: UILabel!
    @IBOutlet private weak var sunriseLabelOutlet: UILabel!
    @IBOutlet private weak var sunsetLabelOutlet: UILabel!
    @IBOutlet private weak var lowTemperatureLabelOutlet: UILabel!
    @IBOutlet private weak var moonIconOutlet: UIImageView!

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

            formatter.dateFormat = "EEEE"
            let dayName = formatter.string(from: forecast.time)
            self.dayNameLabelOutlet.text = dayName.uppercased()

            let moonPhaseIconName = self.getMoonPhaseImageName(moonPhase: forecast.moonPhase)
            self.moonIconOutlet.image = UIImage(named: moonPhaseIconName)
        }
    }

    private func getMoonPhaseImageName(moonPhase: Double?) -> String {

        let moonPhaseInteger = Int((moonPhase ?? 0) * 100)

        switch  moonPhaseInteger {
        case 0:
            return "moon-0"
        case 1...3:
            return "moon-3"
        case 4...6:
            return "moon-6"
        case 7...9:
            return "moon-9"
        case 10...12:
            return "moon-12"
        case 13...15:
            return "moon-15"
        case 16...24:
            return "moon-18"
        case 25:
            return "moon-25"
        case 26...28:
            return "moon-28"
        case 29...31:
            return "moon-31"
        case 33...34:
            return "moon-34"
        case 35...37:
            return "moon-37"
        case 38...40:
            return "moon-40"
        case 41...49:
            return "moon-43"
        case 50:
            return "moon-50"
        case 51...54:
            return "moon-54"
        case 55...58:
            return "moon-58"
        case 59...61:
            return "moon-61"
        case 62...64:
            return "moon-64"
        case 65...67:
            return "moon-67"
        case 68...74:
            return "moon-71"
        case 75:
            return "moon-75"
        case 76...79:
            return "moon-79"
        case 80...83:
            return "moon-83"
        case 84...87:
            return "moon-87"
        case 88...92:
            return "moon-92"
        case 93...95:
            return "moon-95"
        case 96..<100:
            return "moon-97"
        default:
            return "moon-0"
        }
    }
}
