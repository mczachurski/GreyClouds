//
//  ViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, LocationFoundedDelegate, ChangedPlacesDelegate {

    let placesHandler = PlacesHandler()
    var cities:[UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let settingsButton = UIButton(frame: CGRect(x: 20, y: 40, width: 30, height: 30))
        settingsButton.setImage(UIImage(named: "settings"), for: UIControlState.normal)
        // button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        let citiesButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 50, y: 40, width: 30, height: 30))
        citiesButton.setImage(UIImage(named: "cities"), for: UIControlState.normal)
        citiesButton.addTarget(self, action: #selector(openPlacesAction), for: .touchUpInside)

        self.view.addSubview(settingsButton)
        self.view.addSubview(citiesButton)

        // Page view controller.
        self.dataSource = self
        self.delegate = self

        self.cities = createCitiesWeatherViews()

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

    @objc private func openPlacesAction() -> Void {
        self.performSegue(withIdentifier: "placesSegue", sender: self)
    }

    private func createCitiesWeatherViews() -> [UIViewController] {

        var views:[UIViewController] = []
        let places = placesHandler.getPlaces()

        if places.count == 0 {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingViewController")

            if let loadingViewController = viewController as? LoadingViewController {
                loadingViewController.delegate = self
            }

            views.append(viewController)
        } else {
            for place in places {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherViewController")

                if let weatherViewController = viewController as? WeatherViewController {
                    weatherViewController.city = place.name
                    weatherViewController.latitiude = place.latitude
                    weatherViewController.longitude = place.longitude
                }

                views.append(viewController)
            }
        }

        return views
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placesSegue" {
            if let destination = segue.destination.childViewControllers.first as? PlacesTableViewController {
                destination.delegate = self
            }
        }
    }

    func changedPlaces() {
        self.reloadViewControllers()
    }

    func locationFounded() {
        self.reloadViewControllers()
    }

    private func reloadViewControllers() {
        self.cities = createCitiesWeatherViews()

        self.dataSource = nil
        self.dataSource = self

        // First view.
        if let first = cities.first {
        setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
    }

}

