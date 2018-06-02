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
    var foundedPlacemarks:[CLPlacemark] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search location"
        searchController.searchBar.tintColor = UIColor.main

        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        let geocoder = CLGeocoder()
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
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placemark = self.foundedPlacemarks[indexPath.row]

        guard let latitiude = placemark.location?.coordinate.latitude,
            let longitude = placemark.location?.coordinate.longitude else {
                return
        }
        
        let place = self.placesHandler.createPlaceEntity()
        place.id = UUID()
        place.name = placemark.locality
        place.country = placemark.country
        place.latitude = latitiude
        place.longitude = longitude

        CoreDataHandler.shared.saveContext()

        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
