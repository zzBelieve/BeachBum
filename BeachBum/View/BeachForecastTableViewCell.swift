//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import CoreLocation

class BeachForecastTableViewCell: UITableViewCell {
  
  
  var beachForecast: BeachForecast? {
    didSet {
      updateUI()
    }
  }
  var userLocation: CLLocation?
  private var distanceFromUser: CLLocationDistance? {
    print("user location: \(userLocation)")
    let dist = beachForecast?.calculateDistance(from: userLocation)
    print("distance: \(dist)")
    return dist
  }
  
  private var borderColor: UIColor {
    switch beachForecast?.forecast?.currently.icon {
    case "clear-day": return UIColor.orange
    case "rain": return UIColor.blue
    case "partly-cloudy-day", "cloudy": return UIColor.gray
    case "partly-cloudy-night": return UIColor.darkGray
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
    temperatureLabel?.text = beachForecast!.forecast!.currently.temperature.temperatureFormatted
    distanceLabel?.text = "\(Int(distanceFromUser?.distanceInMiles ?? 0)) mi."
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
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
