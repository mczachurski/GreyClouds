//
//  ThirdPartyTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 24/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class ThirdPartyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
}

// MARK: - Table view delegate.
extension ThirdPartyTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.unselectSelectedRow()

        if indexPath.row == 0 {
            "https://github.com/sxg/ForecastIO".openInBrowser()
        } else if indexPath.row == 1 {
            "https://erikflowers.github.io/weather-icons/".openInBrowser()
        } else if indexPath.row == 2 {
            "https://www.flaticon.com/packs/weather-53".openInBrowser()
        }
    }
}

// MARK: - Table view data source.
extension ThirdPartyTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = "ForecastIO"
            cell.detailTextLabel?.text = "A Swift library for the Forecast.io Dark Sky API"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "Weather Icons (flat icons)"
            cell.detailTextLabel?.text = "215 Weather Themed Icons and CSS"
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "Weather (color icons)"
            cell.detailTextLabel?.text = "Designed by Freepik from Flaticon"
        }

        return cell
    }
}
