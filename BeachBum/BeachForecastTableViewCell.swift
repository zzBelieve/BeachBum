//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastTableViewCell: UITableViewCell {
  
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  var model: Model? {
    didSet {
      guard let model = model else { return }
      beachNameLabel.text = model.beachName
      temperatureLabel.text = "\(model.temperature)"
      
    }
  }
}

extension BeachForecastTableViewCell {
  
  struct Model {
    let beachName: String
    let temperature: Double
    
    init(beach: BeachForecast) {
      beachName = beach.name.rawValue
      temperature = beach.forecast.currently.temperature
    }
  }
}
