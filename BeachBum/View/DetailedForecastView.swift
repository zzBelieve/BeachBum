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
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var currentWeatherImageView: UIImageView!
  @IBOutlet weak var sunriseTimeLabel: UILabel! 
  @IBOutlet weak var sunsetTimeLabel: UILabel!
  @IBOutlet weak var windSpeedLabel: UILabel!
  @IBOutlet weak var chanceOfRainLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var circledWeatherIconView: UIView!
  
  @IBOutlet var circledViews: [UIView]! {
    didSet {
      circledViews.forEach {
        let height = $0.frame.size.height
        $0.layer.cornerRadius = height / 2
        $0.layer.borderWidth = 4.0
      }
    }
  }
  
  var mainColor: [UIColor]? { didSet { setMainColorTo(mainColor ?? [.white]) } }
  var beachName: String? { didSet { beachNameLabel?.text = beachName  ?? ""} }
  var temperature: Double? { didSet { currentTemperatureLabel?.text = "\(temperature?.temperatureFormatted ?? "00")"}}
  var summary: String? { didSet { summaryLabel?.text = summary ?? "" } }
  var imageIcon: String? { didSet { currentWeatherImageView?.image = imageIcon?.toImage ?? UIImage()}}
  var sunriseTime: Int? { didSet { sunriseTimeLabel?.text = sunriseTime?.formatTimeAs("h:mm a") ?? "00:00" } }
  var sunsetTime: Int? { didSet { sunsetTimeLabel?.text = sunsetTime?.formatTimeAs("h:mm a") ?? "00:00" } }
  var windSpeed: Double? { didSet { windSpeedLabel?.text = "\(Int(windSpeed ?? 00))mph"}}
  var chanceOfRain: Double? { didSet { chanceOfRainLabel?.text = "\(Int((chanceOfRain ?? 0) * 100 ))%" } }
  var distance: Int? { didSet { distanceLabel?.text = "\(distance ?? 0)mi."}}
  var humidity: Double? { didSet { humidityLabel?.text = "\(Int((humidity ?? 0) * 100))%" } }
  
  private func setMainColorTo(_ colors: [UIColor]) {
    guard let firstColor = colors.first, let secondColor = colors.last else { return }
    circledViews?.forEach {
      $0.layer.borderColor = firstColor.cgColor
    }
    let gradientColor = [firstColor, firstColor, secondColor, secondColor]
    if let topColoredview = topColoredView {
     topColoredview.backgroundColor = UIColor.init(gradientStyle: .leftToRight, withFrame: topColoredview.frame, andColors: gradientColor)
    }
    summaryLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: firstColor, isFlat: true)
    beachNameLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: firstColor, isFlat: true)
    currentTemperatureLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: firstColor, isFlat: true)
    
    
  }
}
