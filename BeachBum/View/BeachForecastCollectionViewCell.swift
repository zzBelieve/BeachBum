//
//  BeachForecastCollectionViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/10/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var temperatureLabel: UILabel! {
    didSet {
      //temperatureLabel?.textColor = .skyBlue
    }
  }
  
  @IBOutlet weak var weatherIconView: UIView! {
    didSet {
      //weatherIconView?.backgroundColor = .sand
      weatherIconView?.layer.cornerRadius = 8.0
    }
  }
  
  @IBOutlet weak var chanceOfRainView: UIView! {
    didSet {
      //chanceOfRainView?.backgroundColor = .sand
      //chanceOfRainView?.layer.backgroundColor =
      chanceOfRainView?.layer.cornerRadius = 8.0
    }
  }
  
  
  @IBOutlet weak var beachNameLabel: UILabel! {
    didSet {
     beachNameLabel?.sizeToFit()
    }
  }
  
  @IBOutlet weak var beachCellView: UIView! {
    didSet {
      //beachCellView?.backgroundColor = .skyBlue
      beachCellView?.layer.borderWidth = 2.0
      beachCellView?.layer.borderColor = UIColor.skyBlue.cgColor
      beachCellView?.layer.cornerRadius = 10.0
    }
  }
  
  
  var model: Model? {
    didSet {
      guard let model = model else { return }
      beachNameLabel?.text = model.beachName
      temperatureLabel?.text = "\(model.temperature)"
      beachNameLabel?.sizeToFit()
    }
  }
  
  
}


extension BeachForecastCollectionViewCell {
  
  struct Model {
    let beachName: String
    let temperature: Double
    init(beach: BeachForecast) {
      beachName = beach.name.rawValue
      temperature = beach.forecast.currently.temperature
    }
  }
}
