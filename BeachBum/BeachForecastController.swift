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
  var beachNames: [Beach] = []
  
  func addForecast(for beachForecast: BeachForecast) {
    beaches.append(beachForecast)
  }
  
  func udpateForecasts(completion: @escaping(() -> Void) ) {
    let dispatchGroup = DispatchGroup()
    
    for beach in beachNames {
      guard let url = beach.url else { print("invalid url"); return}
      dispatchGroup.enter()
      networkController.fetchForecastData(url, completion: {
        let newBeachForecast = BeachForecast(name: BeachName(rawValue: beach.name)!, forecast: $0)
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
