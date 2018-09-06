//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastTableViewCell: UITableViewCell {
  
  private var borderColor: UIColor {
    switch beachForecast?.forecast?.currently.icon {
    case "clear-day": return UIColor.orange
    case "rain": return UIColor.blue
    case "partly-cloudy-day", "cloudy": return UIColor.gray
    case "partly-cloudy-night": return UIColor.purple
    default: return UIColor.white
    }
  }
  
  var beachForecast: BeachForecast? {
    didSet {
     updateUI()
    }
  }
  
  private func updateUI() {
    container.layer.borderColor = borderColor.cgColor
    container.layer.borderWidth = 3.0
    container.layer.cornerRadius = 15.0
    beachNameLabel?.text = beachForecast!.beach.name
    sideOfIslandLabel?.text = "\(beachForecast!.beach.side) side"
    currentSummaryLabel?.text = beachForecast!.forecast!.currently.summary
    if let iconString = beachForecast?.forecast?.currently.icon {
      if let image = UIImage(named: iconString) {
        weatherIconImageView.image = image
      }
    }
    temperatureLabel?.text = "\(beachForecast!.forecast!.currently.temperature.twoDecimalPoints)°"
  }
  
  @IBOutlet weak var container: UIView!
  
  
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var sideOfIslandLabel: UILabel!
  @IBOutlet weak var currentSummaryLabel: UILabel! {
    didSet {
      currentSummaryLabel.sizeToFit()
    }
  }
  @IBOutlet weak var hourlySummary: UILabel!
  
  
  @IBOutlet weak var weatherIconImageView: UIImageView! {
    didSet {
      weatherIconImageView.sizeToFit()
    }
  }
  
  @IBOutlet weak var temperatureLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
