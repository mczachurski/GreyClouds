//
//  DateFormatter.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 23/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation

extension DateFormatter {

    convenience init(timeZone: TimeZone) {
        self.init()

        self.locale = Locale.current
        self.timeZone = timeZone
    }

    public func getDayName(from date: Date) -> String {
        self.dateFormat = "EEEE"

        let dayName = self.string(from: date)
        return dayName
    }

    public func getShortDate(from date: Date) -> String {
        self.dateStyle = .medium
        self.timeStyle = .none

        let shortDate = self.string(from: date)
        return shortDate
    }

    public func getShortTime(from date: Date) -> String {
        self.dateStyle = .none
        self.timeStyle = .short

        let shortDate = self.string(from: date)
        return shortDate
    }

    public func getShortDateTime(from date: Date) -> String {
        self.dateStyle = .short
        self.timeStyle = .short

        let shortDate = self.string(from: date)
        return shortDate
    }
}
