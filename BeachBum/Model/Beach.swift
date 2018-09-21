//
//  Beach.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/8/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Beach: Codable {
  let name: String
  let side: String
  let latitude: Double
  let longitude: Double
  var coordinates: String { return "\(latitude),\(longitude)" }
  var url: URL? { return Beach.baseURL?.appendingPathComponent(coordinates) }
  
  init(name: String, side: String, latitude: Double, longitude: Double) {
    self.name = name
    self.side = side
    self.latitude = latitude
    self.longitude = longitude
  }
  
  init?(json: Data){
    if let newValue = try? JSONDecoder().decode(Beach.self, from: json) {
      self = newValue
    } else {
      return nil
    }
  }
}

extension Beach {
  static private  let baseURL: URL? = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.darksky.net"
    components.path = "/forecast/33833ceebca4249519c0b3845541972a"
    return components.url
  }()
}

extension Beach {
  var json: Data? {
    return try? JSONEncoder().encode(self)
  }
}
