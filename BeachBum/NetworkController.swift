//
//  NetworkController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation


class NetworkController {
  
  //fetch weather forecast given a url, and hands it over to completion
  func fetchForecastData(_ url: URL, completion: @escaping ((Forecast) -> Void)) {
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let data = data else { print("Data failed: \(error!)"); return}
        do {
          let newForecast = try JSONDecoder().decode(Forecast.self, from: data)
          completion(newForecast)
        } catch {
          print(error)
        }
    }
    task.resume()
  }
}
