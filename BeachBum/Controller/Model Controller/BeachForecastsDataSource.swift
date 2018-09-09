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
  
  var beachForecastController: BeachForecastController
  
  init(_ beachForecastController: BeachForecastController) {
    self.beachForecastController = beachForecastController
  }
}

extension BeachForecastsDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecastController.beachForecasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Beach Cell", for: indexPath)
    guard let beachCell = cell as? BeachForecastTableViewCell else { return cell }
    let beachForecast = beachForecastController.beachForecasts[indexPath.item]
    beachCell.beachForecast = beachForecast
    //beachCell.distanceFromUser = beachForecastController.calculateDistanceFrom(beachForecast)
    return cell
  }
}
