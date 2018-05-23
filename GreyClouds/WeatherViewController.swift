//
//  MainViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class WeatherViewController: UIViewController, SwipeMenuViewDelegate, SwipeMenuViewDataSource {

    public var city: String?
    public var latitiude: Double?
    public var longitude: Double?

    @IBOutlet private weak var cityOutlet: UILabel!
    @IBOutlet private weak var summaryOutlet: UILabel!
    @IBOutlet private weak var temperatureOutlet: UILabel!
    @IBOutlet private weak var iconOutlet: UIImageView!
    @IBOutlet private weak var dayDescriptionOutlet: UILabel!

    @IBOutlet weak var swipeMenuView: SwipeMenuView! {
        didSet {
            swipeMenuView.delegate = self
            swipeMenuView.dataSource = self
            swipeMenuView.setCustomOptions()
        }
    }

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
                self.swipeMenuView.reloadData()
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

        self.client.getForecast(latitude: latitiude, longitude: longitude, extendHourly: true) { result in
            switch result {
            case .success(let forecast, _):
                self.forecast = forecast
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    // MARK: - SwipeMenuViewDelegate

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
    }

    // MARK: - SwipeMenuViewDataSource

    func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        guard let days = self.forecast?.daily?.data.count else {
            return 0
        }

        return days > 6 ? 6 : days
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewForPageAt index: Int, withFrame frame: CGRect) -> TabItemView? {
        let tabItemView = CustomTabItemView(frame: frame)

        if let dayData = self.forecast?.daily?.data[index] {
            tabItemView.imageName = dayData.icon?.rawValue

            let roundedLowTemperature = Int(dayData.temperatureLow?.rounded(FloatingPointRoundingRule.toNearestOrEven) ?? 0)
            let roundedHighTemperature = Int(dayData.temperatureHigh?.rounded(FloatingPointRoundingRule.toNearestOrEven) ?? 0)

            tabItemView.details = "\(roundedLowTemperature)º/\(roundedHighTemperature)º"
            tabItemView.isBoldTitle = true
        }


        return tabItemView
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        guard let time = self.forecast?.daily?.data[index].time else {
            return ""
        }

        if index == 0 {
            return "Now"
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: time)
    }

    func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let viewController = UIViewController()

        let forecastView = ForecastsView()
        forecastView.isFirstDay = index == 0
        forecastView.day = self.forecast?.daily?.data[index]
        forecastView.hourly = self.forecast?.hourly

        viewController.view = forecastView
        return viewController
    }
}
