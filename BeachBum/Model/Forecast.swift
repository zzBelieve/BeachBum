//
//  Weather.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Forecast: Codable {
  
  var timezone: String = "Pacific/Honolulu"
  var currently: Currently
  var hourly: Hourly?
  var daily: Daily?
  
  
  enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
  }
  
  struct Currently: Codable {
    let summary: String
    let icon: String
    let temperature: Double
    let apparentTemperature: Double
    let windSpeed: Double
    let precipProbability: Double
    let humidity: Double
  }
  
  struct Hourly: Codable {
    let summary: String
    let icon: String
    let data: [HourlyData]
  }
  
  struct HourlyData: Codable {
    let time: Double
    let summary: String
    let temperature: Double
    let precipProbability: Double
  }
  
  struct Daily: Codable {
    let data: [DailyData]
  }
  
  struct DailyData: Codable {
    let sunriseTime: Int
    let sunsetTime: Int
    let precipProbability: Double
  }
  
  init(timeZone: String = "Pacific/Honolulu", currently: Currently, hourly: Hourly? = nil, daily: Daily? = nil) {
    self.currently = currently
  }
}
