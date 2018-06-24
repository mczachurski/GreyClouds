//
//  Image.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 04.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

public enum ImageType: String {
    case mono = "-mono"
    case dual = "-dual"
    case color = "-color"
}

public enum ImageSize: String {
    case normal = ""
    case small = "-small"
}

public class Image {

    private static var _imageType:ImageType?

    static var imageType: ImageType {
        get {

            if let type = _imageType {
                return type
            }

            let settingsHandler = SettingsHandler()
            let defaultSettings = settingsHandler.getDefaultSettings()

            if let icons = defaultSettings.icons, let type = ImageType.init(rawValue: icons) {
                _imageType = type
                return type
            }

            return ImageType.dual
        }
        set {
            let settingsHandler = SettingsHandler()
            let defaultSettings = settingsHandler.getDefaultSettings()

            defaultSettings.icons = newValue.rawValue
            CoreDataHandler.shared.saveContext()

            _imageType = newValue
        }
    }

    static func fullImageName(forName name: String, withSize size: ImageSize = ImageSize.normal) -> String {
        return name + size.rawValue + Image.imageType.rawValue
    }

    static func image(forName name: String, withSize size: ImageSize = ImageSize.normal) -> UIImage? {
        return UIImage(named: Image.fullImageName(forName: name, withSize: size))
    }
}
