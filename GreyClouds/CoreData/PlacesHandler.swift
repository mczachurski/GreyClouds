//
//  PlacesHandler.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 02.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class PlacesHandler {

    func createPlaceEntity(from placemark: CLPlacemark) -> Place? {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        let place = Place(context: context)

        guard let latitude = placemark.location?.coordinate.latitude,
            let longitude = placemark.location?.coordinate.longitude,
            let timeZone = placemark.timeZone,
            let country = placemark.country else {
                return nil
        }

        var name: String?
        if placemark.locality != nil {
            name = placemark.locality
        } else if placemark.name != nil {
            name = placemark.name
        } else if placemark.administrativeArea != nil {
            name = placemark.administrativeArea
        }

        place.id = UUID()
        place.name = name
        place.country = country
        place.timeZoneIdentifier = timeZone.identifier
        place.latitude = latitude
        place.longitude = longitude

        return place
    }

    func deletePlaceEntity(place: Place) {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        context.delete(place)
    }

    func getPlaces() -> [Place] {
        var places: [Place] = []

        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Place")
        do {
            if let list = try context.fetch(fetchRequest) as? [Place] {
                places = list
            }
        } catch {
            print("Error during fetching ExchangeItem")
        }

        return places
    }
}
