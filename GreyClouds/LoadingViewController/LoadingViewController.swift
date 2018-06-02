//
//  LoadingViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 02.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import CoreLocation

class LoadingViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    let placesHandler = PlacesHandler()

    public weak var delegate: LocationFoundedDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // For use in foreground
        self.isAuthorizedtoGetUserLocation()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }

    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }

        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil {
                if let firstLocation = placemarks?.first,
                    let latitude = firstLocation.location?.coordinate.latitude,
                    let longitude = firstLocation.location?.coordinate.longitude {

                    let place = self.placesHandler.createPlaceEntity()
                    place.id = UUID()
                    place.name = firstLocation.locality
                    place.country = firstLocation.country
                    place.isAutomaticLocation = true
                    place.latitude = latitude
                    place.longitude = longitude

                    CoreDataHandler.shared.saveContext()

                    self.locationManager.stopUpdatingLocation()
                    self.delegate?.locationFounded()
                }
            }
            else {
                // An error occurred during geocoding.
            }
        })
    }

    //this method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
}
