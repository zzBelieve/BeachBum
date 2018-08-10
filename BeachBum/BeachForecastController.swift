//
//  BeachForecastController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

class BeachForecastController {
  
  var beaches: [BeachForecast] = []
  
  func addForecast(for beachForecast: BeachForecast) {
    beaches.append(beachForecast)
  }
  
  //for each name in Beach.name, fetch data for those coordinates and create a new object of BeachForecast and append to beaches
  func udpateForecasts(completion: @escaping(() -> Void) ) {

  }
}


//let keikiBeach = Beach(name: .keiki, latitude: 21.6550, longitude: 158.0600, weather: nil)
//let lanikaiBeach = Beach(name: .lanikai, latitude: 21.3931, longitude: 157.7154, weather: nil)

//
//Beach.coordinates.forEach {  beach in
//  guard let url = Beach.baseURL?.appendingPathComponent(beach.coordinates) else { print("url failed"); return }
//  NetworkController.fetchForecastData(url, completion: { forecast in
//    DispatchQueue.main.async {
//      let newBeachForecast = BeachForecast(name: beach.name, forecast: forecast)
//      self.beaches.append(newBeachForecast)
//      print("added: \(newBeachForecast.name) to beaches")
//      //          print(newBeachForecast.forecast.currently)
//      completion()
//    }
//  })
//}
