//
//  UIColorExtension.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 17.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    public class var main: UIColor {
        return UIColor.namedOrClear(named: "main")
    }

    public class var second: UIColor {
        return UIColor.namedOrClear(named: "second")
    }

    public class var text: UIColor {
        return UIColor.namedOrClear(named: "text")
    }

    public class var light: UIColor {
        return UIColor.namedOrClear(named: "light")
    }

    public class func namedOrClear(named name: String) -> UIColor {
        if let color = UIColor(named: name) {
            return color
        }

        return UIColor.clear
    }
}
