//
//  SettingsHandler.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 24/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import ForecastIO

class SettingsHandler {

    func getDefaultSettings() -> Settings {

        var settingsList: [Settings] = []

        let context = CoreDataHandler.shared.getManagedObjectContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Settings")
        do {
            if let list = try context.fetch(fetchRequest) as? [Settings] {
                settingsList = list
            }
        } catch {
            print("Error during fetching favourites")
        }

        var settings: Settings? = nil
        if settingsList.count == 0 {
            settings = self.createSettingsEntity()
            settings?.icons = ImageType.dual.rawValue
            settings?.isDarkMode = false
            settings?.units =  Units.si.rawValue

            CoreDataHandler.shared.saveContext()
        } else {
            settings = settingsList.first
        }

        return settings!
    }

    private func createSettingsEntity() -> Settings {
        let context = CoreDataHandler.shared.getManagedObjectContext()
        return Settings(context: context)
    }
}
