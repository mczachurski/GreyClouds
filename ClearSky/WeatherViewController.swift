//
//  MainViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class WeatherViewController: UIViewController {

    public var city: String?
    public var latitiude: Double?
    public var longitude: Double?

    @IBOutlet private weak var cityOutlet: UILabel!
    @IBOutlet private weak var summaryOutlet: UILabel!
    @IBOutlet private weak var temperatureOutlet: UILabel!
    @IBOutlet private weak var iconOutlet: UIImageView!
    @IBOutlet private weak var dayDescriptionOutlet: UILabel!

    private let client = DarkSkyClient(apiKey: "2d8311164f8961ecd00c6571939b1737")
    public var forecast: Forecast? {
        didSet {
            DispatchQueue.main.async {
                self.summaryOutlet.text = self.forecast?.currently?.summary

                if let temperature = self.forecast?.currently?.temperature {
                    let roundedTemperature = Int(temperature.rounded(FloatingPointRoundingRule.toNearestOrEven))
                    self.temperatureOutlet.text = "\(roundedTemperature.description)º"
                }

                if let icon = self.forecast?.currently?.icon?.rawValue {
                    self.iconOutlet.image = UIImage(named: icon)
                }

                self.dayDescriptionOutlet.text = self.forecast?.daily?.summary
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setConstantOutlets()
        configureDarkSkyClient()
        downloadForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setConstantOutlets() {
        self.cityOutlet?.text = self.city
    }

    private func configureDarkSkyClient() {
        self.client.units = .si
        self.client.language = Language.polish
    }

    private func downloadForecast() {

        guard let latitiude = self.latitiude, let longitude = self.longitude else {
            return
        }

        self.client.getForecast(latitude: latitiude, longitude: longitude) { result in
            switch result {
            case .success(let forecast, _):
                self.forecast = forecast
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
