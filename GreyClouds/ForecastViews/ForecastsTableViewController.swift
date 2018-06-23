//
//  ForecastsTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 27.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class ForecastsTableViewController: UITableViewController {

    // MARK: - Public properties.
    
    public var place: Place?
    public var forecastForDay: DataPoint?
    public var hourly: DataBlock?

    // MARK: - Private properties.

    private var hourlyForThisDay: [DataPoint] = []

    // MARK: - View controller.

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.light
        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.reloadView()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = self.place?.name
    }

    func reloadView() {
        self.hourlyForThisDay = []

        guard let forecast = self.forecastForDay else {
            return
        }

        guard let hours = hourly?.data else {
            return
        }

        guard let timeZoneIdentifier = place?.timeZoneIdentifier,
            let timeZone = TimeZone(identifier: timeZoneIdentifier) else {
                return
        }

        let formatter = DateFormatter(timeZone: timeZone)
        let forecastForDay = formatter.getShortDate(from: forecast.time)

        for hour in hours {
            let hourForDay = formatter.getShortDate(from: hour.time)
            if forecastForDay == hourForDay {
                self.hourlyForThisDay.append(hour)
            }
        }
    }
}

// MARK: - Table view delegate.
extension ForecastsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 200
        case 1:
            return 50
        default:
            return 175
        }
    }
}

// MARK: - Table view data source.
extension ForecastsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return hourlyForThisDay.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellName = self.getCellNameFor(section: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        switch indexPath.section {
        case 0:
            if let dayDetailsCell = cell as? DayDetailsTableViewCell {
                dayDetailsCell.place = self.place
                dayDetailsCell.forecastForDay = self.forecastForDay
                dayDetailsCell.reloadView()
            }
        case 1:
            if let hourForecastCell = cell as? HourForecastTableViewCell {
                hourForecastCell.place = self.place
                hourForecastCell.forecastForHour = self.hourlyForThisDay[indexPath.row]
                hourForecastCell.reloadView()
            }
        default:
            if let dayStatisticsCell = cell as? DayStatisticsTableViewCell {
                dayStatisticsCell.forecastForDay = self.hourlyForThisDay[indexPath.row]
                dayStatisticsCell.reloadView()
            }
        }

        return cell
    }

    private func getCellNameFor(section: Int) -> String {
        switch section {
        case 0:
            return "day-details"
        case 1:
            return "hour-forecast"
        case 2:
            return "day-stats"
        default:
            return ""
        }
    }
}
