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
  
  static let mockData = MockData()
  
  init() {
    var beach = Beach(name: "Haleiwa", side: "North", latitude: 21.5928, longitude: -158.1034)
    var currently = Forecast.Currently(summary: "Parly Cloudy",
                                       icon: "clear-day",
                                       temperature: 84.40,
                                       apparentTemperature: 90.32,
                                       windSpeed: 6,
                                       precipProbability: 0.20,
                                       humidity: 0.7)
    let haleiwaBeach = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Keiki", side: "North",latitude: 21.655, longitude: -158.06)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "partly-cloudy-day",
                                   temperature: 82.91,
                                   apparentTemperature: 90.32,
                                   windSpeed: 6,
                                   precipProbability: 0.20,
                                   humidity: 0.7)
    let keiki = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Yokohama", side: "West" ,latitude: 21.5578, longitude: -158.2525)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "rain",
                                   temperature: 83.80,
                                   apparentTemperature: 90.32,
                                   windSpeed: 6,
                                   precipProbability: 0.20,
                                   humidity: 0.7)
    let yokohama = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    beach = Beach(name: "Lanikai", side: "East", latitude: 21.3931, longitude: -157.7154)
    currently = Forecast.Currently(summary: "Humid and Mostly Cloudy",
                                   icon: "cloudy",
                                   temperature: 83.35,
                                   apparentTemperature: 90.32,
                                   windSpeed: 6,
                                   precipProbability: 0.20,
                                   humidity: 0.7)
    let lanikai = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    
    self.beachForecasts = [haleiwaBeach, keiki, yokohama, lanikai]
  }
}
