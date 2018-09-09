//
//  BeachForecast.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import CoreLocation

class BeachForecast {
  
  let beach: Beach
  var forecast: Forecast?
  var distanceFromUser: Double?
  
  init(beach: Beach, forecast: Forecast? = nil) {
    self.beach = beach
    self.forecast = forecast
  }
}

extension BeachForecast {
  //given a location, returns distance from this beach's lat,long combination
  func calculateDistance(from location: CLLocation?) -> CLLocationDistance?{
    let lat = CLLocationDegrees(Double(self.beach.latitude))
    let long = CLLocationDegrees(Double(self.beach.longitude))
    let beachLocation = CLLocation(latitude: lat, longitude: long)
    return location?.distance(from: beachLocation)
  }
}
