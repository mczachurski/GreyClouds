//
//  SwipeMenuView.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 14.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension SwipeMenuView {
    func setCustomOptions() {
        var options = SwipeMenuViewOptions()
        options.tabView.style = .segmented
        options.tabView.margin = 8.0
        options.tabView.height = 70.0
        options.tabView.underlineView.backgroundColor = UIColor.gray
        options.tabView.backgroundColor = UIColor.clear
        options.tabView.underlineView.height = 1.0
        options.tabView.itemView.textColor = UIColor.gray
        options.tabView.itemView.selectedTextColor = UIColor.gray
        options.contentScrollView.backgroundColor = UIColor.white

        self.reloadData(options: options)
    }
}
