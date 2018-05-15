//
//  ViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var cities: [UIViewController] = {
        return createCitiesWeatherViews()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Page view controller.
        self.dataSource = self
        self.delegate = self

        // First view.
        if let first = cities.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else {
                view.backgroundColor = UIColor.clear
            }
        }
    }

    private func createCitiesWeatherViews() -> [UIViewController] {

        let viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherViewController")
        if let weatherViewController1 = viewController1 as? WeatherViewController {
            weatherViewController1.city = "Wrocław"
            weatherViewController1.latitiude = 51.146
            weatherViewController1.longitude = 17.12
        }

        let viewController2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherViewController")
        if let weatherViewController2 = viewController2 as? WeatherViewController {
            weatherViewController2.city = "London"
            weatherViewController2.latitiude = 51.5073
            weatherViewController2.longitude = -0.1276
        }

        return [
            viewController1, viewController2
        ]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = cities.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        guard cities.count > previousIndex else {
            return nil
        }

        return cities[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = cities.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex >= 0 else {
            return nil
        }

        guard cities.count > nextIndex else {
            return nil
        }

        return cities[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return cities.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return cities.index(of: pageViewController) ?? 0
    }
}

