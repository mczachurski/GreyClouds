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

    public var forecastForDay: DataPoint?
    public var hourly: DataBlock? {
        didSet {
            self.hourlyForThisDay = []

            guard let forecast = self.forecastForDay else {
                return
            }

            guard let hours = hourly?.data else {
                return
            }

            let calendar = Calendar.current
            let forecastForDayInYear = calendar.component(.day, from: forecast.time)

            for hour in hours {
                let hourInDayInYear = calendar.component(.day, from: hour.time)
                if forecastForDayInYear == hourInDayInYear {
                    self.hourlyForThisDay.append(hour)
                }
            }
        }
    }

    private var hourlyForThisDay: [DataPoint] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.light
        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationItem.title = "Wrocław"
    }

    // MARK: - Table view data source

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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
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
                dayDetailsCell.forecastForDay = self.forecastForDay
            }
        case 1:
            if let hourForecastCell = cell as? HourForecastTableViewCell {
                hourForecastCell.forecastForHour = self.hourlyForThisDay[indexPath.row]
            }
        default:
            if let dayStatisticsCell = cell as? DayStatisticsTableViewCell {
                dayStatisticsCell.forecastForDay = self.hourlyForThisDay[indexPath.row]
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
