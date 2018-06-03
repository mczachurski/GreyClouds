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

            if error != nil {
                return
            }

            guard let placemark = placemarks?.first,
                  let latitude = placemark.location?.coordinate.latitude,
                  let longitude = placemark.location?.coordinate.longitude,
                  let timeZone = placemark.timeZone,
                  let locality = placemark.locality,
                  let country = placemark.country else {
                    // TODO: Information about errro.
                    return
            }

            let place = self.placesHandler.createPlaceEntity()
            place.isAutomaticLocation = true
            place.id = UUID()
            place.name = locality
            place.country = country
            place.timeZoneIdentifier = timeZone.identifier
            place.latitude = latitude
            place.longitude = longitude

            CoreDataHandler.shared.saveContext()

            self.locationManager.stopUpdatingLocation()
            self.delegate?.locationFounded()
        })
    }

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
