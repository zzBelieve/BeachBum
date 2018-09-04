//
//  BeachForecast.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

class BeachForecast {
  
  private(set) var beach: Beach
  var forecast: Forecast?
  
  init(beach: Beach, forecast: Forecast? = nil) {
    self.beach = beach
    self.forecast = forecast
  }
  
}
