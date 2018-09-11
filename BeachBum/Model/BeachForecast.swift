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
  //var distanceFromUser: Double?
  
  init(beach: Beach, forecast: Forecast? = nil) {
    self.beach = beach
    self.forecast = forecast
  }
}
