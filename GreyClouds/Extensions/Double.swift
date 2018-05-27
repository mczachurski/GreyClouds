//
//  Double.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 26.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

extension Double {
    public func toTemperature() -> String {
        let roundedTemperature = Int(self.rounded(FloatingPointRoundingRule.toNearestOrEven))
        let temperature = "\(roundedTemperature.description)º"
        return temperature
    }
}
