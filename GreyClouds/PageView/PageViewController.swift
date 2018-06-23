//
//  ViewController.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 13.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit
import ForecastIO

class PageViewController: UIPageViewController {

    // MARK: - Private properties.

    private let placesHandler = PlacesHandler()
    private var citiesViews: [UIViewController] = []

    // MARK: - Main view controller.

    override func viewDidLoad() {
        super.viewDidLoad()

        // Page view controller delegates.
        self.dataSource = self

        self.createSettingsButton()
        self.createPlacesButton()
        self.createMainApplicationViews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeWeatherScrollView()
    }

    private func resizeWeatherScrollView() {
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }
        }
    }

    // MARK: - Settings button.

    private func createSettingsButton() {
        let settingsButton = UIButton(frame: CGRect(x: 20, y: 40, width: 30, height: 30))
        settingsButton.setImage(UIImage(named: "settings"), for: UIControlState.normal)
        settingsButton.addTarget(self, action: #selector(openSettingsAction), for: .touchUpInside)

        self.view.addSubview(settingsButton)
    }

    @objc private func openSettingsAction() -> Void {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }

    // MARK: - Places button.

    private func createPlacesButton() {
        let citiesButton = UIButton(frame: CGRect(x: self.view.frame.size.width - 50, y: 40, width: 30, height: 30))
        citiesButton.setImage(UIImage(named: "cities"), for: UIControlState.normal)
        citiesButton.addTarget(self, action: #selector(openPlacesAction), for: .touchUpInside)

        self.view.addSubview(citiesButton)
    }

    @objc private func openPlacesAction() -> Void {
        self.performSegue(withIdentifier: "placesSegue", sender: self)
    }

    // MARK: - Create main application views.

    private func createMainApplicationViews() {

        var views: [UIViewController] = []
        let places = placesHandler.getPlaces()

        if places.count == 0 {
            let loadingViewController = createLoadingViewController()
            views.append(loadingViewController)
        } else {
            let weatherViews = createWeatherViewControllers(places)
            views.append(contentsOf: weatherViews)
        }

        self.dataSource = nil
        self.dataSource = self

        self.citiesViews = views
        self.renderFirstView()
    }

    private func renderFirstView() {
        if let first = citiesViews.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }

    private func createLoadingViewController() -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingViewController")

        if let loadingViewController = viewController as? LoadingViewController {
            loadingViewController.delegate = self
        }

        return viewController
    }

    private func createWeatherViewControllers(_ places: [Place]) -> [UIViewController] {
        var views: [UIViewController] = []

        for place in places {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherViewController")

            if let weatherViewController = viewController as? WeatherViewController {
                weatherViewController.place = place
            }

            views.append(viewController)
        }

        return views
    }

    // MARK: - Prepare segues.

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placesSegue" {
            if let destination = segue.destination.childViewControllers.first as? PlacesTableViewController {
                destination.delegate = self
            }
        }
    }
}

// MARK: - Page view controller data source.
extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = citiesViews.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }

        guard citiesViews.count > previousIndex else {
            return nil
        }

        return citiesViews[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let viewControllerIndex = citiesViews.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1
        guard nextIndex >= 0 else {
            return nil
        }

        guard citiesViews.count > nextIndex else {
            return nil
        }

        return citiesViews[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return citiesViews.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return citiesViews.index(of: pageViewController) ?? 0
    }
}

// MARK: - Location founded delegate.
extension PageViewController: LocationFoundedDelegate {
    func locationFounded() {
        self.createMainApplicationViews()
    }
}

// MARK: - Changed place delegate.
extension PageViewController: ChangedPlacesDelegate {
    func changedPlaces() {
        self.createMainApplicationViews()
    }
}
