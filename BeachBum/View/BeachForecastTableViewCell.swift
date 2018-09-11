//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import CoreLocation
import ChameleonFramework

class BeachForecastTableViewCell: UITableViewCell {
  
  
  var beachForecast: BeachForecast? {
    didSet {
      updateUI()
    }
  }
  //var distanceFromUser: Double?
  
  private var borderColor: UIColor {
    switch beachForecast?.forecast?.currently.icon {
    case "clear-day": return UIColor.flatPowderBlue
    case "rain": return UIColor.flatNavyBlue
    case "partly-cloudy-day", "cloudy": return UIColor.flatSkyBlue
    case "partly-cloudy-night": return UIColor.purple
    case "wind": return UIColor.green
    default: return UIColor.white
    }
  }

  
  private func updateUI() {
    accentColorview?.backgroundColor = borderColor
    container.layer.cornerRadius = 8.0
    container.clipsToBounds = true
    beachNameLabel?.text = beachForecast!.beach.name
    sideOfIslandLabel?.text = "\(beachForecast!.beach.side) side"
    currentSummaryLabel?.text = beachForecast!.forecast!.currently.summary
    if let iconString = beachForecast?.forecast?.currently.icon {
      if let image = UIImage(named: iconString) {
        weatherIconImageView.image = image
      }
    }
    temperatureLabel?.text = "\(Int(beachForecast!.forecast!.currently.temperature))°"
    distanceLabel?.text = "\(Int(beachForecast?.distanceFromUser ?? 0)) mi."
  }
  
  @IBOutlet weak var container: UIView!
  
  
  @IBOutlet weak var accentColorview: UIView!
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var sideOfIslandLabel: UILabel!
  @IBOutlet weak var currentSummaryLabel: UILabel! {
    didSet {
      currentSummaryLabel.sizeToFit()
    }
  }
  @IBOutlet weak var weatherIconImageView: UIImageView! {
    didSet {
      weatherIconImageView.sizeToFit()
    }
  }
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
}
