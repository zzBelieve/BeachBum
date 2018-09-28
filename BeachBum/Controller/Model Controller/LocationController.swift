//
//  LocationController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/25/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
  
  let locationManager: CLLocationManager
  var userLocation: CLLocation?
  var ascendingOrder = true
  func configureLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
  }
  
  func updateLocation() { locationManager.startUpdatingLocation() }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else { print("no locations to be found"); return }
    if loc.horizontalAccuracy > 0 {
      print("location found. stopping")
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
  
  func sort(_ beaches: [BeachForecast]) -> [BeachForecast]? {
    var sortedBeachForecasts = [BeachForecast]()
    if userLocation != nil {
      sortedBeachForecasts = beaches.sorted {
        ascendingOrder ? (calculateDistanceFrom($0)! < calculateDistanceFrom($1)!) : (calculateDistanceFrom($0)! > calculateDistanceFrom($1)!)
      }
      ascendingOrder = !ascendingOrder
      return sortedBeachForecasts
    } else {
      return nil
    }
  }
  
  override init() {
    self.locationManager = CLLocationManager()
    super.init()
  }
}

extension CLLocationDistance {
  var distanceInMiles: Int {
    return Int(self * 0.000621371)
  }
}
