//
//  CityTableViewCell.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 01.06.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    // MARK: - Public properties.

    public var place: Place?

    // MARK: - Private properties.

    @IBOutlet private weak var cityLabelOutlet: UILabel!
    @IBOutlet private weak var countryLabelOutlet: UILabel!
    @IBOutlet private weak var navigationImageOutlet: UIImageView!

    // MARK: - Reload view cell.

    public func reloadView() {
        self.cityLabelOutlet.text = place?.name
        self.countryLabelOutlet.text = place?.country
        if let isAutomatic = self.place?.isAutomaticLocation {
            self.navigationImageOutlet.isHidden = !isAutomatic
        }
    }
}
