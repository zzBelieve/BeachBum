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
  
  private var beachForecasts = [BeachForecast]()
  private var filteredBeachForecasts: [BeachForecast]?
  //Service managers
  private let networkController = NetworkController()
  private let locationManager = CLLocationManager()
  
  private var userLocation: CLLocation? { didSet { NotificationCenter.default.post(name: .UserLocationObserver, object: self) } }
  
  //Vars for sorting and filtering
  private var isFiltered = false
  private var distanceSortedDownward = true
  private var temperatureSortDownward = true
  private var weatherSortedDownward = true
  
}

extension BeachForecastController {
  //Helper Interface Variable and Method
  var beachForecastsCount: Int { return filteredBeachForecasts?.count ?? beachForecasts.count }
  
  func beachForecastForIndexAt(_ index: Int) -> BeachForecast {
    return filteredBeachForecasts?[index] ?? beachForecasts[index]
  }
  
  func addBeachForecast(_ beachForecast: BeachForecast) {
    beachForecasts.append(beachForecast)
    print("beach appended to forecasts")
  }
  
  func removeBeach(_ beachForecast: BeachForecast) {
    if let index = beachForecasts.index(where: { $0.beach.name == beachForecast.beach.name }) {
      beachForecasts.remove(at: index)
    }
    print("beach removed from forecasts")
  }
  
  func removeBeach(at index: Int) {
    if filteredBeachForecasts != nil {
      if let removedBeach = filteredBeachForecasts?.remove(at: index) {
       removeBeach(removedBeach)
      }
    } else {
     beachForecasts.remove(at: index)
    }
    print("beach removed from forecasts")
  }
}

//MARK: Network calls for forecasts and beach names
extension BeachForecastController {
  //Retrieve a list of names from the online database.
  //Pass the list through the completion so that
  //the following fetch forecast call can use the list of beaches
  //to fetch all forecasts
  func retrieveBeachNames(completion: @escaping ([Beach]) -> Void) {
    networkController.fetchData { completion($0) }
  }
  
  //For each beach retrieved from Database, make a network call to fetch the forecast
  //Use Beach and Forecast to make a new object of type BeachForecast and append to
  //Beach Forecast array
  func updateForecasts(for beachNames: [Beach], completion: @escaping(() -> Void) ) {
    let dispatchGroup = DispatchGroup()
    var newBeachForecasts = [BeachForecast]()
    for beach in beachNames {
      if let url = beach.url {
        dispatchGroup.enter()
        networkController.fetchForecast(url) { forecast in
          let newBeachForecast = BeachForecast(beach, forecast)
          newBeachForecasts.append(newBeachForecast)
          dispatchGroup.leave()
        }
      }
    }
    dispatchGroup.notify(queue: .main) { [weak self] in
      self?.beachForecasts = newBeachForecasts
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
      case .weatherCondition:
        return weatherSortedDownward ? (b1.forecast!.currently.icon < b2.forecast!.currently.icon) : (b1.forecast!.currently.icon > b2.forecast!.currently.icon)
      case .distance:
        return distanceSortedDownward ? (calculateDistanceFrom(b1)! < calculateDistanceFrom(b2)!) : (calculateDistanceFrom(b1)! > calculateDistanceFrom(b2)!)
      }
    }
    
    switch sortType {
    case .temperature: temperatureSortDownward = !temperatureSortDownward
    case .weatherCondition: weatherSortedDownward = !weatherSortedDownward
    case .distance: distanceSortedDownward = !distanceSortedDownward
    }
  }
  
  func filterBeachesBy(_ searchString: String?) {
    guard let searchString = searchString else { print("no search criteria"); return }
    switch searchString.lowercased() {
    case "all": filteredBeachForecasts = nil; return
    case "north": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "North" }
    case "east": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "East" }
    case "south": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "South" }
    case "west": filteredBeachForecasts = beachForecasts.filter { $0.beach.side == "West" }
    default: filteredBeachForecasts = beachForecasts.filter { $0.beach.name.lowercased().contains(searchString.lowercased()) }
    }
  }
}

//MARK: Location manager
extension BeachForecastController: CLLocationManagerDelegate {
  func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  func updateLocation() { locationManager.startUpdatingLocation() }
  
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
