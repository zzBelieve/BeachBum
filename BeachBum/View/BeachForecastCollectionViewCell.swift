//
//  BeachForecastCollectionViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/10/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastTableViewCell: UITableViewCell {
  
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
  @IBOutlet weak var weatherIconImageView: UIImageView! {
    didSet {
//      UIView.animate(withDuration: 2.0, delay: 0.0, options: .repeat, animations: {
//        self.weatherIconImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
//
//      })
    }
  }
  
  @IBOutlet weak var chanceOfRainView: UIView!
  
  @IBOutlet weak var chanceOfRainLabel: UILabel! {
    didSet {
      chanceOfRainLabel.sizeToFit()
    }
  }
  
  @IBOutlet weak var distanceView: UIView! {
    didSet {
      //chanceOfRainView?.backgroundColor = .sand
      //chanceOfRainView?.layer.backgroundColor =
      distanceView?.layer.cornerRadius = 8.0
    }
  }
  
  @IBOutlet weak var distanceLabel: UILabel! {
    didSet {
      distanceLabel.sizeToFit()
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


extension BeachForecastTableViewCell {
  
  struct Model {
    let beachName: String
    let temperature: Double
    init(beachForecast: BeachForecast) {
      beachName = beachForecast.beach.name
      temperature = beachForecast.forecast?.currently.temperature ?? 00
    }
  }
}
