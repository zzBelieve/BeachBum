//
//  BeachForecast.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import CoreLocation

struct BeachForecast {
  
  let beach: Beach
  let forecast: Forecast?
  
  init(_ beach: Beach, _ forecast: Forecast) {
    self.beach = beach
    self.forecast = forecast
  }
}
