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

class PlacesHandler {
    func createPlaceEntity() -> Place {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return Place(context: context)
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
