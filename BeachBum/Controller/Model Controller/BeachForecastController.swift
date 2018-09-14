//
//  BeachForecastController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import CoreLocation

class BeachForecastController: NSObject {
  
  var beachForecasts = [BeachForecast]()
  var filteredBeachForecasts = [BeachForecast]()
  //Service managers
  let networkController = NetworkController()
  let locationManager = CLLocationManager()
  
  var userLocation: CLLocation? { didSet { NotificationCenter.default.post(name: .UserLocationObserver, object: self) } }
  
  //Vars for sorting and filtering
  var isFiltered = false
  private var distanceSortedDownward = true
  private var temperatureSortDownward = true
  private var regionSortedDownward = true
  private var weatherSortedDownward = true
}

//MARK: Network calls for forecasts and beach names
extension BeachForecastController {
  
  func updateForecasts(completion: @escaping(() -> Void) ) {
    let dispatchGroup = DispatchGroup()
    for bf in beachForecasts {
      if let url = bf.beach.url {
        dispatchGroup.enter()
        networkController.fetchForecast(url) { forecast in
          bf.forecast = forecast
          dispatchGroup.leave()
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion()
    }
  }
  
  func retrieveBeacheNames(completion: @escaping () -> Void) {
    networkController.fetchData { [weak self] fetchedBeachForecasts in
      self?.beachForecasts = fetchedBeachForecasts
      completion()
    }
  }
}

//Mark: Sorting and filtering functions
extension BeachForecastController {
  func sortBeachForecasts(_ sortType: Sort) {
    beachForecasts.sort { (b1, b2) -> Bool in
      switch sortType {
      case .temperature:
        return temperatureSortDownward ? b1.forecast!.currently.temperature < b2.forecast!.currently.temperature : b1.forecast!.currently.temperature > b2.forecast!.currently.temperature
      case .side:
        return regionSortedDownward ? (b1.beach.side < b2.beach.side) : (b1.beach.side > b2.beach.side)
      case .weatherCondition:
        return weatherSortedDownward ? (b1.forecast!.currently.icon < b2.forecast!.currently.icon) : (b1.forecast!.currently.icon > b2.forecast!.currently.icon)
      case .distance:
        return distanceSortedDownward ? (calculateDistanceFrom(b1)! < calculateDistanceFrom(b2)!) : (calculateDistanceFrom(b1)! > calculateDistanceFrom(b2)!)
      }
    }
    
    switch sortType {
    case .temperature: temperatureSortDownward = !temperatureSortDownward
    case .side: regionSortedDownward = !regionSortedDownward
    case .weatherCondition: weatherSortedDownward = !weatherSortedDownward
    case .distance: distanceSortedDownward = !distanceSortedDownward
    }
  }
  
  func filterBeachesBy(_ searchString: String?, _ sideOfIsland: String?) {
    if searchString == "All" { isFiltered = false; return}
    
    if let searchString = searchString {
      filteredBeachForecasts = beachForecasts.filter {
        $0.beach.name.lowercased().contains(searchString.lowercased())
      }
    }
    isFiltered = true
  }
}

//MARK: Location manager
extension BeachForecastController: CLLocationManagerDelegate {
  func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else { print("no locations to be found"); return }
    if loc.horizontalAccuracy > 0 {
      self.locationManager.stopUpdatingLocation()
      let lat = loc.coordinate.latitude
      let long = loc.coordinate.longitude
      userLocation = CLLocation(latitude: lat, longitude: long)
    }
  }
  
  func calculateDistanceFrom(_ beachForecast: BeachForecast) -> Int? {
    let lat = CLLocationDegrees(Double(beachForecast.beach.latitude))
    let long = CLLocationDegrees(Double(beachForecast.beach.longitude))
    let beachLocation = CLLocation(latitude: lat, longitude: long)
    return userLocation?.distance(from: beachLocation).distanceInMiles
  }
}

extension Notification.Name {
  static let UserLocationObserver = Notification.Name(rawValue: "UserLocationObserver")
}

extension CLLocationDistance {
  var distanceInMiles: Int {
      return Int(self * 0.000621371)
  }
}
