//
//  IconsTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 24/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class IconsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }
}

// MARK: - Table view delegate.
extension IconsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - Table view data source.
extension IconsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iconCell", for: indexPath)

        if let iconsTableViewCell = cell as? IconsTableViewCell {
            if indexPath.row == 0 {
                iconsTableViewCell.iconsNameOutlet.text = "Mono"
                iconsTableViewCell.imageOutlet.image = UIImage(named: "partly-cloudy-day-small-mono")
                iconsTableViewCell.accessoryType = Image.imageType == ImageType.mono ?
                    UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            } else if indexPath.row == 1 {
                iconsTableViewCell.iconsNameOutlet.text = "Dual"
                iconsTableViewCell.imageOutlet.image = UIImage(named: "partly-cloudy-day-small-dual")
                iconsTableViewCell.accessoryType = Image.imageType == ImageType.dual ?
                    UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            } else if indexPath.row == 2 {
                iconsTableViewCell.iconsNameOutlet.text = "Multi"
                iconsTableViewCell.imageOutlet.image = UIImage(named: "partly-cloudy-day-small-color")
                iconsTableViewCell.accessoryType = Image.imageType == ImageType.color ?
                    UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
            }
        }

        let selectionColor = UIView()
        selectionColor.backgroundColor = UIColor.light
        cell.selectedBackgroundView = selectionColor

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 0 {
            Image.imageType = ImageType.mono
        } else if indexPath.row == 1 {
            Image.imageType = ImageType.dual
        } else if indexPath.row == 2 {
            Image.imageType = ImageType.color
        }

        self.navigationController?.popViewController(animated: true)
    }
}
