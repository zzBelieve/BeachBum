//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ChameleonFramework

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout, BeachForecastsViewDelegate {
  
  //Mock Data for testing
  let mockData = MockData()
  
  //BeachForecastController handles logic of beach forecasts
  //and fetching of beach forecast data
  var beachForecastController = BeachForecastController()
  
  let refresher = UIRefreshControl()
  //Mark: Outlets
  @IBOutlet weak var beachForecastTableView: UITableView! {
    didSet {
      beachForecastTableView.backgroundColor = .flatWhite
      beachForecastTableView.delegate = self
      beachForecastTableView.dataSource = self
      refresher.addTarget(self, action: #selector(refreshForecasts), for: .valueChanged)
      beachForecastTableView.refreshControl = refresher
    }
  }
  
  @IBOutlet var beachForecastsView: BeachForecastsView! { didSet { beachForecastsView.delegate = self } }
  
  func sortButtonPressed(_ sortType: Sort) {
    beachForecastController.sortBeachForecasts(sortType)
    beachForecastTableView?.reloadSections([0], with: .automatic)
  }
  
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    beachForecastController.updateForecasts { [weak self] in
      self?.beachForecastTableView?.reloadSections([0], with: .automatic)
    }
    beachForecastController.locationManager.startUpdatingLocation()
    beachForecastTableView?.refreshControl?.endRefreshing()
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureSearchController()
    NotificationCenter.default.addObserver(forName: .UserLocationObserver,
                                           object: self.beachForecastController,
                                           queue: OperationQueue.main) { [weak self] (_) in
                                            self?.beachForecastTableView?.reloadSections([0], with: .automatic)
    }
    beachForecastController.configureLocationManager()
    //beachForecastController.beachForecasts = mockData.beachForecasts
    retrievedata()
    beachForecastController.locationManager.startUpdatingLocation()
    
  }
  
  //MARK: Separating retrieve and fetch functions for better testing
  //can consolidate once testing is done
  //retrieve beach names then fetch forecasts
  private func retrievedata() {
    print("calling retrievBeachNames to retrieve beaches from Firebase")
    beachForecastController.retrieveBeacheNames { [weak self] in
      self?.fetchForecasts()
    }
  }
  
  private func fetchForecasts() {
    print("calling fetchForecast to obtain forecast for all beaches")
    beachForecastController.updateForecasts { [weak self] in
      print("forecast has been finished updating")
      print("setting the data source")
      self?.beachForecastTableView?.reloadSections([0], with: .automatic)
    }
  }
  
}

//MARK: Search
extension BeachForecastsViewController: UISearchResultsUpdating {
  
  private func configureSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Beaches"
    definesPresentationContext = true
    navigationItem.searchController = searchController
    //can remove below code once decided if needed or not
    //navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    //if search bar is empty then return entire beach forecast
    beachForecastController.filterBeachesBy((searchBarIsEmpty ? "All" : searchController.searchBar.text!), nil)
    beachForecastTableView.reloadSections([0], with: .automatic)
  }
}

//MARK: Data Source
extension BeachForecastsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecastController.filteredBeachForecasts?.count ?? beachForecastController.beachForecasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "Beach Cell", for: indexPath) as? BeachForecastTableViewCell else { return UITableViewCell() }
    let beachForecast = beachForecastController.filteredBeachForecasts?[indexPath.item] ?? beachForecastController.beachForecasts[indexPath.item]
    cell.accentColor = beachForecast.forecast?.currently.icon.colorFromString[0]
    cell.beachName = beachForecast.beach.name
    cell.sideOfIsland = beachForecast.beach.side
    cell.summary = beachForecast.forecast?.currently.summary ?? "no summary"
    cell.temperature = Int(beachForecast.forecast?.currently.temperature ?? 0)
    cell.iconString = beachForecast.forecast?.currently.icon ?? "no icon"
    cell.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
    return cell
  }
}

//MARK: Delegate Methods
extension BeachForecastsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    beachForecastTableView?.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 8.0
  }
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let detailedForecastVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = beachForecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      let beachForecast = beachForecastController.filteredBeachForecasts?[indexPath.row] ?? beachForecastController.beachForecasts[indexPath.row]
      detailedForecastVC.beachForecast = beachForecast
      detailedForecastVC.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
    }
  }
}

//MARK: extension for String gives color based off of icon string
extension String {
  var colorFromString: [UIColor] {
    switch self {
    case "clear-day": return [.flatSkyBlue, .flatSkyBlueDark]
    case "rain": return [.flatBlue, .flatBlueDark]
    case "partly-cloudy-day", "cloudy": return [.flatPowderBlue, .flatPowderBlueDark]
    case "partly-cloudy-night": return [.flatPlum, .flatPlumDark]
    case "wind": return [.flatMintDark, .flatMintDark]
    case "clear-night": return [.flatNavyBlue, .flatNavyBlueDark]
    default: return [.white, .white]
    }
  }
}
