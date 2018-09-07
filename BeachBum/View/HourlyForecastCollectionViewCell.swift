//
//  HourlyForecastCollectionViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
  
  var hourlyData: Forecast.HourlyData? {
    didSet {
      updateUI()
    }
  }
  
  @IBOutlet weak var temperatureLabel: UILabel!
  
  
  private func updateUI() {
    temperatureLabel?.text = hourlyData?.temperature.temperatureFormatted
  }
}
