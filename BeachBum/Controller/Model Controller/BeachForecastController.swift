//
//  BeachForecastController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

class BeachForecastController {
  
  var beachForecasts = [BeachForecast]()
  var networkController = NetworkController() //any network calls should be done through this controller
  var beachNames = [Beach]()
  
  func addForecast(for beachForecast: BeachForecast) {
    beachForecasts.append(beachForecast)
  }
  
  func updateForecasts(completion: @escaping(() -> Void) ) {
    let dispatchGroup = DispatchGroup()
    for bf in beachForecasts {
      if let url = bf.beach.url {
        dispatchGroup.enter()
        networkController.fetchForecast(url) { forecast in
          //TODO: finish appending data
          bf.forecast = forecast
          dispatchGroup.leave()
        }
      }
    }
    dispatchGroup.notify(queue: .main) {
      completion()
    }
  }
  
  func retrieveBeacheNames(completion: @escaping () -> Void) {
    networkController.fetchData { [weak self] in  //$0 is an array of BeachForecast
      self?.beachForecasts = $0
      print("Beach name retrieval finished")
      completion()
    }
  }
}
