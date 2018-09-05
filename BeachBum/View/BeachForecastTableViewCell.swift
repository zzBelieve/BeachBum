//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastTableViewCell: UITableViewCell {
  
  var beachForecast: BeachForecast? {
    didSet {
      //TODO set labels
      temperatureLabel?.text = "\(beachForecast!.forecast!.currently.temperature)°"
      beachNameLabel?.text = beachForecast!.beach.name
      currentSummaryLabel?.text = beachForecast!.forecast!.currently.summary
      if let iconString = beachForecast?.forecast?.currently.icon {
        if let image = UIImage(named: iconString) {
          weatherIconImageView.image = image
        }
      }
    }
  }
  
  @IBOutlet weak var beachNameLabel: UILabel!
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

extension BeachForecastTableViewCell {
  
}
