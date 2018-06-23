//
//  LoadingViewController.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 02.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import CoreLocation

class LoadingViewController: UIViewController {

    // MARK: - Public properties.

    public weak var delegate: LocationFoundedDelegate?

    // MARK: - Private properties.
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let placesHandler = PlacesHandler()

    // MARK: - View controller.

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - Location manager delegate.
extension LoadingViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else {
            return
        }

        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in

            guard error == nil, let placemark = placemarks?.first else {
                // TODO: Show error.
                return
            }

            let place = self.placesHandler.createPlaceEntity(from: placemark)
            guard place != nil else {
                // TODO: Show error.
                return
            }

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
