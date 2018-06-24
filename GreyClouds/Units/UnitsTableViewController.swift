//
//  UnitsTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 24/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class UnitsTableViewController: UITableViewController {

    private let settingsHandler = SettingsHandler()
    private var defaultSettings: Settings?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.defaultSettings = settingsHandler.getDefaultSettings()
    }
}

// MARK: - Table view delegate.
extension UnitsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Table view data source.
extension UnitsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unitCell", for: indexPath)

        if let settings = defaultSettings {
            if indexPath.row == 0 {
                cell.textLabel?.text = "SI"
                cell.detailTextLabel?.text = NSLocalizedString("SI units description", comment: "SI units description")
                cell.accessoryType = settings.units == Units.si.rawValue
                    ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "US"
                cell.detailTextLabel?.text = NSLocalizedString("US units description", comment: "US units description")
                cell.accessoryType = settings.units == Units.us.rawValue
                    ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "UK"
                cell.detailTextLabel?.text = NSLocalizedString("UK units description", comment: "UK units description")
                cell.accessoryType = settings.units == Units.uk.rawValue
                    ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "CA"
                cell.detailTextLabel?.text = NSLocalizedString("CA units description", comment: "CA units description")
                cell.accessoryType = settings.units == Units.ca.rawValue
                    ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let settings = defaultSettings else {
            return
        }

        if indexPath.row == 0 {
            settings.units = Units.si.rawValue
        } else if indexPath.row == 1 {
            settings.units = Units.us.rawValue
        } else if indexPath.row == 2 {
            settings.units = Units.uk.rawValue
        } else if indexPath.row == 3 {
            settings.units = Units.ca.rawValue
        }

        CoreDataHandler.shared.saveContext()

        self.navigationController?.popViewController(animated: true)
    }
}
