//
//  UnitsTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 24/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class UnitsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
}

// MARK: - Table view delegate.
extension UnitsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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

        if indexPath.row == 0 {
            cell.textLabel?.text = "SI"
            cell.detailTextLabel?.text = NSLocalizedString("SI units description", comment: "SI units description")
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "US"
            cell.detailTextLabel?.text = NSLocalizedString("US units description", comment: "US units description")
        } else if indexPath.row == 2 {
            cell.textLabel?.text = "UK"
            cell.detailTextLabel?.text = NSLocalizedString("UK units description", comment: "UK units description")
        } else if indexPath.row == 3 {
            cell.textLabel?.text = "CA"
            cell.detailTextLabel?.text = NSLocalizedString("CA units description", comment: "CA units description")
        }

        return cell
    }
}
