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
  
  var beachForecasts = [BeachForecast]() {
    didSet {
      if userLocation != nil {
        print("beaches received. setting distance from user")
        beachForecasts.forEach { $0.distanceFromUser = self.calculateDistanceFrom($0) }
      }
    }
  }
  var networkController = NetworkController() //any network calls should be done through this controller
  var beachNames = [Beach]()
  let locationManager = CLLocationManager()
  
  var userLocation: CLLocation? {
    didSet {
      print("User location updated. Sending message via notification post")
      print("updating distance from each beach")
      beachForecasts.forEach {
        $0.distanceFromUser = self.calculateDistanceFrom($0)
      }
      NotificationCenter.default.post(name: .UserLocationObserver, object: self)
    }
  }
  
  private var alphaSortDownward = true
  private var temperatureSortDownward = true
  private var regionSortedDownward = true
  private var weatherSortedDownward = true
  
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
  
  func sortBeachForecasts(_ sortType: Sort) {
    beachForecasts.sort { (b1, b2) -> Bool in
      switch sortType {
      case .alphabetical:
        return alphaSortDownward ? (b1.beach.name < b2.beach.name) : (b1.beach.name > b2.beach.name)
      case .temperature:
        return temperatureSortDownward ? b1.forecast!.currently.temperature < b2.forecast!.currently.temperature : b1.forecast!.currently.temperature > b2.forecast!.currently.temperature
      case .side:
        return regionSortedDownward ? (b1.beach.side < b2.beach.side) : (b1.beach.side > b2.beach.side)
      case .weatherCondition:
        return weatherSortedDownward ? (b1.forecast!.currently.icon < b2.forecast!.currently.icon) : (b1.forecast!.currently.icon > b2.forecast!.currently.icon)
      }
    }
    
    switch sortType {
    case .alphabetical: alphaSortDownward = !alphaSortDownward
    case .temperature: temperatureSortDownward = !temperatureSortDownward
    case .side: regionSortedDownward = !regionSortedDownward
    case .weatherCondition: weatherSortedDownward = !weatherSortedDownward
    }
  }
  
  func retrieveBeacheNames(completion: @escaping () -> Void) {
    networkController.fetchData { [weak self] in  //$0 is an array of BeachForecast
      self?.beachForecasts = $0
      print("Beach name retrieval finished")
      completion()
    }
  }
}

//Manage location
extension BeachForecastController: CLLocationManagerDelegate {
  func configureLocationManager() {
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
    }
  }
  
  func calculateDistanceFrom(_ beachForecast: BeachForecast) -> Double? {
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
  var distanceInMiles: Double {
      return self * 0.000621371
  }
}
