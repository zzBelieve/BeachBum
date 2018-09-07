//
//  HourlyForecastDataSource.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class HourlyForecastDataSource: NSObject {
  
  let hourlyForecast: Forecast.Hourly
  
  init(hourlyForecast: Forecast.Hourly) {
    print("within hourly data source")
    self.hourlyForecast = hourlyForecast
  }
}

extension HourlyForecastDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyForecast.data.count
    //return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hourly Forecast Cell", for: indexPath)
    guard let hourlyCell = cell as? HourlyForecastCollectionViewCell  else { print("not able to set as hourly cell"); return cell}
    hourlyCell.hourlyData = hourlyForecast.data[indexPath.item]
    //hourlyCell.temperatureLabel?.text = "TEST"
    return cell
  }
  
}
