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

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Enter location", comment: "Text in search placeholder")
        searchController.searchBar.tintColor = UIColor.main

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

        guard let latitude = placemark.location?.coordinate.latitude,
              let longitude = placemark.location?.coordinate.longitude,
              let timeZone = placemark.timeZone,
              let locality = placemark.locality,
              let country = placemark.country else {
                // TODO: Information about errro.
                return
        }
        
        let place = self.placesHandler.createPlaceEntity()
        place.id = UUID()
        place.name = locality
        place.country = country
        place.timeZoneIdentifier = timeZone.identifier
        place.latitude = latitude
        place.longitude = longitude

        CoreDataHandler.shared.saveContext()
        self.navigationController?.popViewController(animated: true)
    }
}
