//
//  NetworkController.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import Firebase

class NetworkController {
  
  //Fetch weather forecast given a url, and hands it over to completion
  func fetchForecast(_ url: URL, completion: @escaping ((Forecast) -> Void)) {
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
  
  //Fetch name data for beaches from Firebase
  func fetchData(completion: @escaping ([BeachForecast]) -> Void) {
    let beachesDB = Database.database().reference().child("Beaches")
    //OBSERVE IS OFF OF THE MAIN THREAD
    beachesDB.observeSingleEvent(of: .value) { (snapshot) in
      guard let snapshot = snapshot.value as? Dictionary<String, Any> else { print("unable to retrive snapshot") ; return }
      var beachForecasts = [BeachForecast]()
      for value in snapshot {
        guard let keyValue = value.value as? Dictionary<String, Any> else  { return }
        guard let name = keyValue["Name"] as? String else {print("can't find name"); return }
        guard let lat = keyValue["Latitude"] as? Double, let long = keyValue["Longitude"] as? Double else { return }
        guard let side = keyValue["Side"] as? String else { return }
        let beach = Beach(name: name, side: side, latitude: lat, longitude: long)
        beachForecasts.append(BeachForecast(beach: beach))
      }
      completion(beachForecasts)
    }
  }
}
