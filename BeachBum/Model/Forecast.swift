//
//  Weather.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Forecast: Codable {
  
  var currently: Currently
  var hourly: Hourly?
  
  enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
  }
  
  struct Currently: Codable {
    let summary: String
    let icon: String
    let temperature: Double
    let apparentTemperature: Double
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
  }
}
