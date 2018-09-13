//
//  DetailedForecastView.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

class DetailedForecastView: UIView {

  @IBOutlet weak var topColoredView: UIView!
  @IBOutlet weak var detailsView: UIView! { didSet { detailsView.layer.cornerRadius = 10.0 } }
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var currentWeatherImageView: UIImageView!
  @IBOutlet weak var sunriseTimeLabel: UILabel! 
  @IBOutlet weak var sunsetTimeLabel: UILabel!
  @IBOutlet weak var windSpeed: UILabel!
  @IBOutlet weak var chanceOfRainLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  
  @IBOutlet weak var circledWeatherIconView: UIView! {
    didSet {
      circledWeatherIconView?.layer.cornerRadius = (circledWeatherIconView?.frame.size.width ?? 0) / 2
      circledWeatherIconView?.layer.borderWidth = 2.0
      
    }
  }
  
  @IBOutlet var circledViews: [UIView]! {
    didSet {
      circledViews?.forEach {
        let height = $0.frame.size.height
        $0.layer.cornerRadius = height / 2
        $0.layer.borderWidth = 4.0
      }
    }
  }
  
  func setThemeColorTo(_ color: [UIColor]) {
    circledViews?.forEach {
      $0.layer.borderColor = color.first!.cgColor
    }
    //TODO set top colored view
    
    
  }
  
  @IBOutlet weak var sunriseCircleView: UIView!
  @IBOutlet weak var windSpeedCircleView: UIView!
  
  @IBOutlet weak var distanceCircleView: UIView!
  
}
