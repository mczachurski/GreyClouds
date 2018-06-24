//
//  SettingsTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 23/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class SettingsTableViewController: UITableViewController {

    // MARK: - Private properties.
    
    @IBOutlet private weak var iconsOutlet: UITableViewCell!
    @IBOutlet private weak var unitsOutlet: UITableViewCell!
    @IBOutlet private weak var thirdPartyOutlet: UITableViewCell!
    @IBOutlet private weak var sourceCoudeOutlet: UITableViewCell!
    @IBOutlet private weak var reportIssueOutlet: UITableViewCell!
    @IBOutlet private weak var followMeOutlet: UITableViewCell!
    @IBOutlet private weak var versionOutlet: UITableViewCell!

    private let settingsHandler = SettingsHandler()

    // MARK: - View controller.

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true

        changeSelectionColor()
        self.versionOutlet.detailTextLabel?.text = getAppVersion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if Image.imageType == ImageType.mono {
            iconsOutlet.detailTextLabel?.text = "Mono"
        } else if Image.imageType == ImageType.dual {
            iconsOutlet.detailTextLabel?.text = "Dual"
        } else if Image.imageType == ImageType.color {
            iconsOutlet.detailTextLabel?.text = "Multi"
        }

        let defaultSettings = settingsHandler.getDefaultSettings()
        if defaultSettings.units == Units.si.rawValue {
            unitsOutlet.detailTextLabel?.text = "SI"
        } else if defaultSettings.units == Units.us.rawValue {
            unitsOutlet.detailTextLabel?.text = "US"
        } else if defaultSettings.units == Units.uk.rawValue {
            unitsOutlet.detailTextLabel?.text = "UK"
        } else if defaultSettings.units == Units.ca.rawValue {
            unitsOutlet.detailTextLabel?.text = "CA"
        }
    }

    private func changeSelectionColor() {
        let selectionColor = UIView()
        selectionColor.backgroundColor = UIColor.light

        iconsOutlet.selectedBackgroundView = selectionColor
        unitsOutlet.selectedBackgroundView = selectionColor
        thirdPartyOutlet.selectedBackgroundView = selectionColor
        sourceCoudeOutlet.selectedBackgroundView = selectionColor
        reportIssueOutlet.selectedBackgroundView = selectionColor
        followMeOutlet.selectedBackgroundView = selectionColor
    }

    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    func getAppVersion() -> String {
        return "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? "")"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - Table view delegate.
extension SettingsTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.unselectSelectedRow()

        if indexPath.section == 1 && indexPath.row == 1 {
            "https://github.com/mczachurski/GreyClouds".openInBrowser()
        } else if indexPath.section == 1 && indexPath.row == 2 {
            "https://github.com/mczachurski/GreyClouds/issues".openInBrowser()
        } else if indexPath.section == 1 && indexPath.row == 3 {
            "https://twitter.com/mczachurski".openInBrowser()
        }
    }
}
