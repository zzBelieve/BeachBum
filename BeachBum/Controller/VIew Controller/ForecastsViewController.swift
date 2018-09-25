//
//  ForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/19/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ChameleonFramework

class ForecastsViewController: UIViewController, BeachForecastsViewDelegate {
  
  //BeachForecastController handles logic of beach forecasts
  //and fetching of beach forecast data
  var beachForecastController = BeachForecastController()
  let refresher = UIRefreshControl()
  let networkController = NetworkController()
  
  let storageController = StorageController()
  var favoriteBeaches = [Beach]()
  //Mark: Outlets
  @IBOutlet weak var forecastTableView: UITableView! {
    didSet {
      forecastTableView?.backgroundColor = .flatWhite
      forecastTableView?.delegate = self
      forecastTableView?.dataSource = self
      refresher.addTarget(self, action: #selector(refreshForecasts), for: .valueChanged)
      forecastTableView?.refreshControl = refresher
    }
  }
  
  //the view that this view controller is presenting
  @IBOutlet var forecastsView: BeachForecastsView! { didSet { forecastsView.delegate = self } }
  
  func sortButtonPressed(_ sortType: Sort) {
    beachForecastController.sortBeachForecasts(sortType)
    forecastTableView?.reloadSections([0], with: .automatic)
  }
  
  func retrieveBeaches() {
    //fetch beaches either from the network or from the disk
    //and returns array of beaches
    
    //call fetch forecasts at the end of this method
  }
  
  func fetchForecasts(for beaches: [Beach], completion: @escaping ([BeachForecast]) -> Void) {
    let dispatchGroup = DispatchGroup()
    var newBeachForecasts = [BeachForecast]()
    for beach in beaches {
      if let url = beach.url {
        dispatchGroup.enter()
        networkController.fetchForecast(url) { forecast in
          let newBeachForecast = BeachForecast(beach, forecast)
          newBeachForecasts.append(newBeachForecast)
          dispatchGroup.leave()
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion(newBeachForecasts)
    }
  }
  
  func addMockData() {
    MockData.mockBeachForecasts.forEach {
      beachForecastController.addBeachForecast($0)
    }
  }
}

//MARK: View Lifecycle
extension ForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSearchController()
    NotificationCenter.default.addObserver( forName: .UserLocationObserver, object: self.beachForecastController, queue: OperationQueue.main) { [weak self] (_) in
      self?.forecastTableView?.reloadSections([0], with: .automatic)
    }
    beachForecastController.configureLocationManager()
    beachForecastController.updateLocation()
    retrieveBeaches()
    favoriteBeaches = storageController.loadData() ?? [Beach]()
    
    if let navBar = navigationController?.navigationBar {
      navBar.barTintColor = .white
      navBar.setBackgroundImage(UIImage(), for: .default)
      navBar.shadowImage = UIImage()
      navBar.isTranslucent = true
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    favoriteBeaches = storageController.loadData() ?? [Beach]()
    if let navBar = navigationController?.navigationBar {
      navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
      navBar.largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Nunito-ExtraBold", size: 40.0)!]
    }

  }
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    retrieveBeaches()
    beachForecastController.updateLocation()
    forecastTableView?.refreshControl?.endRefreshing()
  }
}

//MARK: Search
extension ForecastsViewController: UISearchResultsUpdating {
  
  private func configureSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Beaches"
    definesPresentationContext = true
    navigationItem.searchController = searchController
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    //if search bar is empty then return entire beach forecast
    beachForecastController.filterBeachesBy((searchBarIsEmpty ? "All" : searchController.searchBar.text))
    forecastTableView?.reloadSections([0], with: .automatic)
  }
}

//MARK: Data Source
extension ForecastsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecastController.beachForecastsCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Beach Cell", for: indexPath) as? BeachForecastTableViewCell else { return UITableViewCell() }
    let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.item)
    let distance = beachForecastController.calculateDistanceFrom(beachForecast) ?? 00
    cell.model = BeachForecastCellViewModel(beachForecast, distance)
    return cell
  }
}

//MARK: Delegate Methods
extension ForecastsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    forecastTableView?.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8.0
  }
}

//MARK: Navigation
extension ForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let detailedForecastVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = forecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.item)
      detailedForecastVC.beachForecast = beachForecast
      detailedForecastVC.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
    }
  }
}
