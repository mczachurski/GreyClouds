//
//  PlacesTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 01.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class PlacesTableViewController: UITableViewController {

    // MARK: - Public properties.

    public weak var delegate: ChangedPlacesDelegate?

    // MARK: - Private properties.

    private let placesHandler = PlacesHandler()
    private var places: [Place] = []

    // MARK: - View controller.

    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.places = self.placesHandler.getPlaces()
        self.tableView.reloadData()
    }

    // MARK: - Actions.

    @IBAction func cancelAction(_ sender: Any) {
        self.delegate?.changedPlaces()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "openSearchLocation", sender: self)
    }
}

// MARK: - Table view delegate.
extension PlacesTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 44
        }
    }
}

// MARK: - Table view data source.
extension PlacesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.places.count
        default:
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellName = self.getCellNameFor(section: indexPath.section)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)

        if indexPath.section == 0 {
            if let cityTableViewCell = cell as? CityTableViewCell {
                let place = self.places[indexPath.row]
                cityTableViewCell.place = place
                cityTableViewCell.reloadView()
            }
        }

        return cell
    }

    private func getCellNameFor(section: Int) -> String {
        switch section {
        case 0:
            return "city-cell"
        case 1:
            return "city-settings-cell"
        default:
            return ""
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let place = self.places[indexPath.row]
        if place.isAutomaticLocation {
            return false
        }

        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default,
                                                title: NSLocalizedString("Delete", comment: "Text under the cell"),
                                                handler: { (_: UITableViewRowAction, indexPath: IndexPath) -> Void in
                                                    let place = self.places[indexPath.row]
                                                    self.placesHandler.deletePlaceEntity(place: place)
                                                    CoreDataHandler.shared.saveContext()

                                                    self.places = self.placesHandler.getPlaces()
                                                    self.tableView.reloadData()
        })

        deleteAction.backgroundColor = UIColor.main
        return [deleteAction]
    }
}
