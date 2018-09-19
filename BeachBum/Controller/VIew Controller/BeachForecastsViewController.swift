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
  
  //BeachForecastController handles logic of beach forecasts
  //and fetching of beach forecast data
  var beachForecastController = BeachForecastController()
  var storageController = StorageController()
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
  
  
  //MARK: Separating retrieve and fetch functions for better testing
  //can consolidate once testing is done
  //retrieve beach names then fetch forecasts
  func retrievedata() {
        print("calling retrieveBeachNames to retrieve beaches from Firebase")
        beachForecastController.retrieveBeachNames { [weak self] in
          self?.fetchForecasts(for: $0)
        }
//    MockData.mockBeachForecasts.forEach {
//      beachForecastController.addBeachForecast($0)
//    }
  }
  
  func fetchForecasts(for beaches: [Beach]) {
    print("calling fetchForecast to obtain forecast for all beaches")
    beachForecastController.updateForecasts(for: beaches) { [weak self] in
      print("forecast has been finished updating")
      print("setting the data source")
      self?.beachForecastTableView?.reloadSections([0], with: .automatic)
    }
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureSearchController()
    NotificationCenter.default.addObserver(
      forName: .UserLocationObserver,
      object: self.beachForecastController,
      queue: OperationQueue.main) {
        [weak self] (_) in
        self?.beachForecastTableView?.reloadSections([0], with: .automatic)
    }
    beachForecastController.configureLocationManager()
    retrievedata()
    beachForecastController.updateLocation()
  }
  
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    retrievedata()
    beachForecastController.updateLocation()
    beachForecastTableView?.refreshControl?.endRefreshing()
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
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    var searchBarIsEmpty: Bool { return searchController.searchBar.text?.isEmpty ?? true }
    //if search bar is empty then return entire beach forecast
    beachForecastController.filterBeachesBy((searchBarIsEmpty ? "All" : searchController.searchBar.text))
    beachForecastTableView.reloadSections([0], with: .automatic)
  }
}

//MARK: Data Source
extension BeachForecastsViewController: UITableViewDataSource {
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
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
    let leadingSwipeAction = UIContextualAction(style: .normal, title: "Add To Favorites") { (action, view, completion) in
      if StorageController.favoriteBeaches.contains(where: { $0.name == beachForecast.beach.name}) {
        print("Already in favorites")
        completion(false)
      } else {
        print("Adding to favorites")
        if let navCon = self.tabBarController?.viewControllers?.last as? UINavigationController {
          if let favoriteBeachesVC = navCon.viewControllers.first as? FavoriteBeachesViewController {
              favoriteBeachesVC.addBeachForecast(beachForecast)
          }
        }
        completion(true)
      }
    }
    leadingSwipeAction.backgroundColor = .flatMint
    return UISwipeActionsConfiguration(actions: [leadingSwipeAction])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      return UISwipeActionsConfiguration(actions: [])
  }
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let detailedForecastVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = beachForecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.item)
      detailedForecastVC.beachForecast = beachForecast
      detailedForecastVC.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
    }
  }
}

