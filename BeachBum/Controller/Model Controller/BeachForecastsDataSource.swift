//
//  BeachForecastsDataSource.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class BeachForecastsDataSource: NSObject {
  
  var beachForecastController: BeachForecastController
  var userLocation: CLLocation?
  
  init(_ beachForecastController: BeachForecastController, _ userLocation: CLLocation?) {
    self.beachForecastController = beachForecastController
    self.userLocation = userLocation
  }
  
}

extension BeachForecastsDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecastController.beachForecasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Beach Cell", for: indexPath)
    guard let beachCell = cell as? BeachForecastTableViewCell else { return cell }
    beachCell.beachForecast = beachForecastController.beachForecasts[indexPath.item]
    beachCell.userLocation = self.userLocation
    return cell
  }
}
