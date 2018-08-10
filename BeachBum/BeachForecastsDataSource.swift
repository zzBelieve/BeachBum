//
//  BeachForecastsDataSource.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class BeachForecastsDataSource: NSObject {
  
  var beachForecasts: [BeachForecast]
  
  init(beachForecasts: [BeachForecast]) {
    self.beachForecasts = beachForecasts
  }
  
}

extension BeachForecastsDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
      //Beach.beachList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeachCell", for: indexPath)
//    guard let beachCell = cell as? BeachForecastCollectionViewCell else { return cell }
//    
//    //check if a forecast exists in the array if so, set the cell's model to be that object
//    if let beachForecast = beachForecasts.first(where: {$0.name == Beach.beachList[indexPath.row].name}) {
//      beachCell.model = BeachForecastCollectionViewCell.Model(beach: beachForecast)
//    } else {
//      //else make a network call to fetch a forecast and then set the cell's model to be that object
//      
//      guard let url = Beach.baseURL?.appendingPathComponent(Beach.beachList[indexPath.row].coordinates) else { print("Invalid URL"); return cell }
//      NetworkController.fetchForecastData(url, completion: { weather in
//        DispatchQueue.main.async {
//          let newBeachForecast = BeachForecast(name: Beach.beachList[indexPath.row].name, forecast: weather)
//          self.beachForecasts.append(newBeachForecast)
//          beachCell.model = BeachForecastCollectionViewCell.Model(beach: newBeachForecast)
//        }
//      })
//    }
    
    return cell
  }
}
