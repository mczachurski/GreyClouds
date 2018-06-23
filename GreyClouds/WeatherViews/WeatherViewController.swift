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

    // MARK: - Public properties.

    public var place: Place?

    public var forecast: Forecast? {
        didSet {
            DispatchQueue.main.async {
                self.summaryOutlet.text = self.forecast?.currently?.summary

                if let temperature = self.forecast?.currently?.temperature {
                    self.temperatureOutlet.text = temperature.toTemperature()
                }

                if let icon = self.forecast?.currently?.icon?.rawValue {
                    self.iconOutlet.image = Image.image(forName: icon)
                }

                self.dayDescriptionOutlet.text = self.forecast?.daily?.summary
                self.tableViewOutlet.reloadData()
            }
        }
    }

    // MARK: - Private properties.

    @IBOutlet private weak var cityOutlet: UILabel!
    @IBOutlet private weak var summaryOutlet: UILabel!
    @IBOutlet private weak var temperatureOutlet: UILabel!
    @IBOutlet private weak var iconOutlet: UIImageView!
    @IBOutlet private weak var dayDescriptionOutlet: UILabel!
    @IBOutlet private weak var tableViewOutlet: UITableView!

    private var forecastDownloadedTime: Date?

    // MARK: - View controller.

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dayDescriptionOutlet.text = NSLocalizedString("Loading weather...", comment: "Text before downloading weather")
        self.summaryOutlet.text = ""
        self.temperatureOutlet.text = "-"
        self.iconOutlet.image = Image.image(forName: "satellite")

        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self

        setConstantOutlets()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.downloadForecast()

        if let selectedIndexPath = tableViewOutlet.indexPathForSelectedRow {
            tableViewOutlet.deselectRow(at: selectedIndexPath, animated: true)
        }

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setConstantOutlets() {
        self.cityOutlet?.text = self.place?.name
    }

    // MARK: - Download forecast.

    private func downloadForecast() {

        guard let latitude = self.place?.latitude, let longitude = self.place?.longitude else {
            return
        }

        if forecast != nil && !forecastShouldBeDownloaded() {
            return
        }

        let client = createDarkSkyClient()
        client.getForecast(latitude: latitude, longitude: longitude, extendHourly: true, excludeFields: [.minutely]) { result in
            switch result {
            case .success(let forecast, _):
                self.forecastDownloadedTime = Date()
                self.forecast = forecast
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func createDarkSkyClient() -> DarkSkyClient {
        let client = DarkSkyClient(apiKey: "")
        client.units = .si

        switch Locale.current.languageCode {
        case "pl":
            client.language = Language.polish
        default:
            client.language = Language.english
        }

        return client
    }

    private func forecastShouldBeDownloaded() -> Bool {
        let timeInterval = self.forecastDownloadedTime?.timeIntervalSinceNow
        return timeInterval ?? 0 > 60
    }

    // MARK: - Prepare segues.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forecast" {
            if let destination = segue.destination as? ForecastsTableViewController {
                if let selectedPath = self.tableViewOutlet.indexPathForSelectedRow {
                    destination.place = self.place
                    destination.forecastForDay = self.forecast?.daily?.data[selectedPath.row - 1]
                    destination.hourly = self.forecast?.hourly
                }
            }
        }
    }
}

// MARK: - Table view delegate.
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 30 : 62
    }
}

// MARK: - Table view data source.
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.forecast?.daily?.data.count ?? 0) + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = indexPath.row == 0 ? "empty" : "weather"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        guard let weatherItemTableViewCell = cell as? WeatherItemTableViewCell else {
            return cell
        }

        let selectionColor = UIView()
        selectionColor.backgroundColor = UIColor.light
        weatherItemTableViewCell.selectedBackgroundView = selectionColor

        weatherItemTableViewCell.place = self.place
        weatherItemTableViewCell.forecastForDay = self.forecast?.daily?.data[indexPath.row - 1]
        weatherItemTableViewCell.reloadView()

        return weatherItemTableViewCell
    }
}
