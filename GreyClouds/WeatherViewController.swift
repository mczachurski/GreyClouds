//
//  MainViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public var city: String?
    public var latitiude: Double?
    public var longitude: Double?

    @IBOutlet private weak var cityOutlet: UILabel!
    @IBOutlet private weak var summaryOutlet: UILabel!
    @IBOutlet private weak var temperatureOutlet: UILabel!
    @IBOutlet private weak var iconOutlet: UIImageView!
    @IBOutlet private weak var dayDescriptionOutlet: UILabel!
    @IBOutlet private weak var tableViewOutlet: UITableView!

    private let client = DarkSkyClient(apiKey: "2d8311164f8961ecd00c6571939b1737")
    public var forecast: Forecast? {
        didSet {
            DispatchQueue.main.async {
                self.summaryOutlet.text = self.forecast?.currently?.summary

                if let temperature = self.forecast?.currently?.temperature {
                    self.temperatureOutlet.text = temperature.toTemperature()
                }

                if let icon = self.forecast?.currently?.icon?.rawValue {
                    self.iconOutlet.image = UIImage(named: icon)
                }

                self.dayDescriptionOutlet.text = self.forecast?.daily?.summary
                self.tableViewOutlet.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self

        setConstantOutlets()
        configureDarkSkyClient()
        downloadForecast()
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecast?.daily?.data.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weather", for: indexPath)

        guard let weatherItemTableViewCell = cell as? WeatherItemTableViewCell else {
            return cell
        }

        weatherItemTableViewCell.forecastForDay = self.forecast?.daily?.data[indexPath.row]

        return weatherItemTableViewCell
    }
}
