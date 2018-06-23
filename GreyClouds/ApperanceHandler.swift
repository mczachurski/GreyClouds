//
//  ApperanceHandler.swift
//  GreyClouds
//
//  Created by Marcin Czachurski on 05/06/2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import Foundation
import UIKit

public class ApperanceHandler {
    public static func apply(window: UIWindow?) {
        ApperanceHandler.applyPageControlApperance()
        ApperanceHandler.applyNavigationBarApperance()
        ApperanceHandler.applyApplicationApperance(window)
    }

    private static func applyPageControlApperance() {
        let appearance =  UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.pageIndicatorTintColor = UIColor.light
        appearance.currentPageIndicatorTintColor = UIColor.main
    }

    private static func applyNavigationBarApperance() {
        UINavigationBar.appearance().shadowImage = UIImage()
    }

    private static func applyApplicationApperance(_ window: UIWindow?) {
        window?.backgroundColor = UIColor.white
    }
}
