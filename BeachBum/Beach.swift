//
//  Beach.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/8/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

struct Beach {
  
  var name: BeachName
  var latitude: Double
  var longitude: Double
  var coordinates: String { return "\(latitude),\(longitude)" }

}

extension Beach {
  static var beachList: [Beach] = [Beach(name: .keiki, latitude: 21.6550, longitude: -158.0600),
                                   Beach(name: .lanikai, latitude: 21.3931, longitude: -157.7154),
                                   Beach(name: .haleiwa, latitude: 21.5928, longitude: -158.1034)
]
  static let baseURL: URL? = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.darksky.net"
    components.path = "/forecast/33833ceebca4249519c0b3845541972a"
    return components.url
  }() 
}

enum BeachName: String {
  case keiki
  case lanikai
  case haleiwa
  static var all = [BeachName.keiki, .lanikai, .haleiwa]
}
//Beach(name: .lanikai, latitude: 21.3931, longitude: 157.7154)
