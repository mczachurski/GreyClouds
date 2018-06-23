//
//  SearchLocationTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 02.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import CoreLocation

class SearchLocationTableViewCell: UITableViewCell {

    // MARK: - Public properties.
    
    public var placemark:CLPlacemark?

    // MARK: - Reload view cell.
    
    public func reloadView() {
        self.textLabel?.text = self.placemark?.name
        self.detailTextLabel?.text = self.placemark?.country
    }
}
