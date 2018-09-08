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

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout, BeachForecastsViewDelegate {
  
  //Mock Data for testing
  let mockData = MockData()
  
  let refresher = UIRefreshControl()
  
  //MARK: Injected Objects
  var beachForecastController = BeachForecastController()
  private var dataSource: BeachForecastsDataSource? {
    didSet {
      beachForecastTableView?.dataSource = dataSource
      beachForecastTableView?.reloadSections([0], with: .fade)
    }
  }
  let locationManager = CLLocationManager()
  private var userLocation: CLLocation? {
    didSet {
      print("user location updated: \(userLocation)")
      dataSource = BeachForecastsDataSource(beachForecastController, userLocation)
    }
  }
  
  @IBOutlet weak var beachForecastTableView: UITableView! {
    didSet {
      beachForecastTableView.delegate = self
      refresher.addTarget(self, action: #selector(refreshForecasts), for: .valueChanged)
      beachForecastTableView.refreshControl = refresher
    }
  }
  
  @IBOutlet var beachForecastsView: BeachForecastsView! {
    didSet {
      beachForecastsView.delegate = self
    }
  }
  
  func sortButtonPressed(_ sortType: Sort) {
    beachForecastController.sortBeachForecasts(sortType)
    dataSource = BeachForecastsDataSource(beachForecastController, userLocation)
  }
  
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    beachForecastController.updateForecasts { [weak self] in
      print("forecast has been finished updating")
      print("setting the data source")
      self?.dataSource = BeachForecastsDataSource(self!.beachForecastController, self!.userLocation)
    }
    beachForecastTableView.refreshControl?.endRefreshing()
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
    //beachForecastController.beachForecasts = mockData.beachForecasts; dataSource = BeachForecastsDataSource(beachForecastController, userLocation)
    retrievedata()
    
  }
  
  private func retrievedata() {
    print("calling retrievBeachNames to retrieve beaches from Firebase")
    beachForecastController.retrieveBeacheNames { [weak self] in
      print("calling fetchForecast to obtain forecast for all beaches")
      self?.beachForecastController.updateForecasts { [weak self] in
        print("forecast has been finished updating")
        print("setting the data source")
        self?.dataSource = BeachForecastsDataSource(self!.beachForecastController, self?.userLocation)
      }
    }
  }
}

extension BeachForecastsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    beachForecastTableView.cellForRow(at: indexPath)?.isSelected = false
  }
  
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let destinationVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = beachForecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      destinationVC.beachForecast = beachForecastController.beachForecasts[indexPath.row]
      destinationVC.userLocation = userLocation
    }
  }
}

extension BeachForecastsViewController: CLLocationManagerDelegate{
  private func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else { print("no locations to be found"); return }
    if loc.horizontalAccuracy > 0 {
      self.locationManager.stopUpdatingLocation()
      let lat = loc.coordinate.latitude
      let long = loc.coordinate.longitude
      userLocation = CLLocation(latitude: lat, longitude: long)
      print(userLocation)
    }
  }
}
