//
//  Beach.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/8/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Beach {
  var name: String
  var latitude: Double
  var longitude: Double
  var coordinates: String { return "\(latitude),\(longitude)" }
  var url: URL? { return Beach.baseURL?.appendingPathComponent(coordinates) }
  
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
