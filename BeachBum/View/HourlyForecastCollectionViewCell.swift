//
//  HourlyForecastCollectionViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class HourlyForecastCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!

  var model: HourlyForecastCellViewModel? {
    didSet {
      guard let model = model else { return }
      timeLabel?.text = model.timeString
      weatherIconImageView?.image = model.weatherImage
      temperatureLabel?.text = model.temperatureString
    }
  }
}

struct HourlyForecastCellViewModel {
  var timeString: String
  var weatherImage: UIImage
  var temperatureString: String
  
  init(_ hourlyForecast: Forecast.HourlyData) {
    self.timeString = hourlyForecast.time.formatTimeAs("h a")
    self.weatherImage = hourlyForecast.icon.toImage ?? UIImage()
    self.temperatureString = "\(Int(hourlyForecast.temperature))°"
  }
}

