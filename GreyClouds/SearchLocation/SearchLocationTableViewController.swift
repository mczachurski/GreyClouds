//
//  SearchLocationTableViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 02.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import CoreLocation

class SearchLocationTableViewController: UITableViewController, UISearchResultsUpdating {

    let searchController = UISearchController(searchResultsController: nil)
    let placesHandler = PlacesHandler()
    let geocoder = CLGeocoder()
    var foundedPlacemarks:[CLPlacemark] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Enter location", comment: "Text in search placeholder")
        searchController.searchBar.tintColor = UIColor.main
        searchController.searchBar.barTintColor = UIColor.main

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true

        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationItem.hidesSearchBarWhenScrolling = true
    }

    // MARK: - UISearchResultsUpdating Delegate

    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getCoordinate), object: self.searchController.searchBar)
        self.perform(#selector(self.getCoordinate), with: self.searchController.searchBar, afterDelay: 0.5)
    }

    @objc func getCoordinate(searchBar : UISearchBar) {

        guard let searchText = searchBar.text else {
            self.foundedPlacemarks = []
            self.tableView.reloadData()
            return
        }

        geocoder.geocodeAddressString(searchText) { (placemarks, error) in

            if error != nil {
                self.foundedPlacemarks = []
                self.tableView.reloadData()
                return
            }

            if let allPlacemarks = placemarks {
                self.foundedPlacemarks = allPlacemarks
            } else {
                self.foundedPlacemarks = []
            }

            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.foundedPlacemarks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchLocationCell", for: indexPath)

        if let searchLocationTableViewCell = cell as? SearchLocationTableViewCell {
            searchLocationTableViewCell.placemark = self.foundedPlacemarks[indexPath.row]
            searchLocationTableViewCell.reloadView()
        }

        let selectionColor = UIView()
        selectionColor.backgroundColor = UIColor.light
        cell.selectedBackgroundView = selectionColor

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = self.foundedPlacemarks[indexPath.row]
        let place = self.placesHandler.createPlaceEntity(from: placemark)

        guard place != nil else {
            // TODO: Show error.
            return
        }

        CoreDataHandler.shared.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
}
