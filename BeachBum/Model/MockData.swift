//
//  MockData.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct MockData {
  
  var beachForecasts: [BeachForecast]
  
  init() {
    var beach = Beach(name: "Haleiwa", latitude: 21.5928, longitude: -158.1034)
    var currently = Forecast.Currently(summary: "Parly Cloudy",
                                       icon: "partly-cloudy-day",
                                       temperature: 84.40,
                                       apparentTemperature: 90.32)
    let haleiwaBeach = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Keiki", latitude: 21.655, longitude: -158.06)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "partly-cloudy-day",
                                   temperature: 82.91,
                                   apparentTemperature: 90.32)
    let keiki = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Yokohama", latitude: 21.5578, longitude: -158.2525)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "partly-cloudy-day",
                                   temperature: 83.80,
                                   apparentTemperature: 90.32)
    let yokohama = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Lanikai", latitude: 21.3931, longitude: -157.7154)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "partly-cloudy-day",
                                   temperature: 83.35,
                                   apparentTemperature: 90.32)
    let lanikai = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    self.beachForecasts = [haleiwaBeach, keiki, yokohama, lanikai]
  }
}
