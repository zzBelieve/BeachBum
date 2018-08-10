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

extension BeachForecastsDataSource: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return beachForecasts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BeachCell", for: indexPath)
    cell.textLabel?.text = "\(beachForecasts[indexPath.item].name)"
    cell.detailTextLabel?.text = "\(beachForecasts[indexPath.item].forecast.currently)"
    return cell
  }
  
  
 
}
