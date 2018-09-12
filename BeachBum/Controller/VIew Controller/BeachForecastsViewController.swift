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
//import ChameleonFramework

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout, BeachForecastsViewDelegate {
  
  //Mock Data for testing
  let mockData = MockData()
  
  let refresher = UIRefreshControl()
  
  //MARK: Injected Objects
  var beachForecastController = BeachForecastController()
  
  @IBOutlet weak var beachForecastTableView: UITableView! {
    didSet {
      beachForecastTableView?.backgroundColor = UIColor.flatWhite
      beachForecastTableView?.delegate = self
      beachForecastTableView?.dataSource = self
      refresher.addTarget(self, action: #selector(refreshForecasts), for: .valueChanged)
      beachForecastTableView?.refreshControl = refresher
    }
  }
  
  @IBOutlet var beachForecastsView: BeachForecastsView! {
    didSet {
      beachForecastsView.delegate = self
    }
  }
  
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
    beachForecastTableView.refreshControl?.endRefreshing()
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    if let navigationBar = navigationController?.navigationBar {
      navigationBar.isTranslucent = false
      navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationBar.shadowImage = UIImage()
    }
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

//MARK: Data Source
extension BeachForecastsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecastController.beachForecasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Beach Cell", for: indexPath)
    guard let beachCell = cell as? BeachForecastTableViewCell else { return cell }
    let beachForecast = beachForecastController.beachForecasts[indexPath.item]
    beachCell.beachForecast = beachForecast
    beachCell.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
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
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let detailedForecastVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = beachForecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      let beachForecast = beachForecastController.beachForecasts[indexPath.row]
      detailedForecastVC.beachForecast = beachForecast
      detailedForecastVC.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
      
    }
  }
}
