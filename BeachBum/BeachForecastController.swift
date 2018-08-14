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
  var networkController = NetworkController()
  let beachNames: [Beach] = [Beach(name: .keiki, latitude: 21.6550, longitude: -158.0600),
                            Beach(name: .lanikai, latitude: 21.3931, longitude: -157.7154),
                            Beach(name: .haleiwa, latitude: 21.5928, longitude: -158.1034)]
  
  func addForecast(for beachForecast: BeachForecast) {
    beaches.append(beachForecast)
  }
  
  //for each name in Beach.name, fetch data for those coordinates and create a new object of BeachForecast and append to beaches
  func udpateForecasts(completion: @escaping(() -> Void) ) {
    let dispatchGroup = DispatchGroup()
    
    for beach in beachNames {
      guard let url = beach.url else { print("invalid url"); return}
      dispatchGroup.enter()
      networkController.fetchForecastData(url, completion: {
        let newBeachForecast = BeachForecast(name: beach.name, forecast: $0)
        self.beaches.append(newBeachForecast)
        print("\(newBeachForecast.name) was fetched and appended")
        dispatchGroup.leave()
      })
    }
    dispatchGroup.notify(queue: .main, execute: {
      completion()
    })
  }
}



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
