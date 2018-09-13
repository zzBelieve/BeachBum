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
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
//    formatter.dateStyle = .none
//    formatter.timeStyle = .short
    formatter.dateFormat = "h a"
    formatter.timeZone = TimeZone(abbreviation: "HST")
    return formatter
  }()
  
  private func timeToString(withSeconds seconds: Int?) -> String? {
    guard let seconds = seconds else { print("seconds not avail"); return nil }
    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
    return dateFormatter.string(from: date)
  }
  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var weatherIconImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  private func updateUI() {
    temperatureLabel?.text = "\(Int(hourlyData!.temperature))°"
    if let iconString = hourlyData?.icon {
      if let image = UIImage(named: iconString) {
        weatherIconImageView.image = image
      }
    }
    timeLabel?.text = timeToString(withSeconds: hourlyData!.time)
    self.sizeToFit()
  }
  
}
