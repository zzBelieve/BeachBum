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
  
  var time: Int? { didSet { timeLabel?.text = time?.formatTimeAs("h a") ?? "--" } }
  var weatherIcon: String? { didSet { weatherIconImageView?.image = weatherIcon?.toImage ?? UIImage() } }
  var temperature: Double? { didSet { temperatureLabel?.text = "\(Int(temperature ?? 0))°"}}
}

