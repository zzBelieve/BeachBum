//
//  Weather.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Forecast: Codable {
  
  let currently: Currently
  let hourly: Hourly?
  let daily: Daily?
  
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
    let time: Int
    let summary: String
    let temperature: Double
    let precipProbability: Double
    let icon: String
  }
  
  struct Daily: Codable {
    let data: [DailyData]
  }
  
  struct DailyData: Codable {
    let sunriseTime: Int
    let sunsetTime: Int
    let precipProbability: Double
  }
  
  //Keeping init for Mock data
  init(currently: Currently, hourly: Hourly? = nil, daily: Daily? = nil) {
    self.currently = currently
    self.hourly = nil
    self.daily = nil
  }
}
