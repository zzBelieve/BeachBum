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
  
  var model: DetailedForecastViewModel? {
    didSet {
      guard let model = model else { return }
      beachNameLabel?.text = model.beachName
      currentTemperatureLabel?.text = model.temperatureString
      summaryLabel?.text = model.temperatureString
      currentWeatherImageView?.image = model.weatherImage
      sunriseTimeLabel?.text = model.sunrriseTimeString
      sunsetTimeLabel?.text = model.sunsetTimmeString
      windSpeedLabel?.text = model.windSpeedstring
      chanceOfRainLabel?.text = model.chanceOfRainString
      distanceLabel?.text = model.distanceString
      humidityLabel?.text = model.humidityString
      setMainColorTo(model.colors)
    }
  }
  
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

struct DetailedForecastViewModel {
  var beachName: String
  var temperatureString: String
  var summary: String
  var weatherImage: UIImage
  var sunrriseTimeString: String
  var sunsetTimmeString: String
  var windSpeedstring: String
  var chanceOfRainString: String
  var distanceString: String
  var humidityString: String
  var colors: [UIColor]
  
  init(_ beachForecast: BeachForecast, _ distanceFromUser: Int?) {
    self.beachName = beachForecast.beach.name
    self.temperatureString = "\(beachForecast.forecast?.currently.temperature.temperatureFormatted ?? "00")"
    self.summary = beachForecast.forecast?.currently.summary ?? "..."
    self.weatherImage = beachForecast.forecast?.currently.icon.toImage ?? UIImage()
    self.sunrriseTimeString = "\(beachForecast.forecast?.daily?.data.first?.sunriseTime.formatTimeAs("h:mm a") ?? "00:00")"
    self.sunsetTimmeString = "\(beachForecast.forecast?.daily?.data.first?.sunsetTime.formatTimeAs("h:mm a") ?? "00:00")"
    self.windSpeedstring = "\(Int(beachForecast.forecast?.currently.windSpeed ?? 00))mph"
    self.chanceOfRainString = "\(Int((beachForecast.forecast?.daily?.data.first?.precipProbability ?? 0) * 100 ))%"
    self.distanceString = "\(distanceFromUser ?? 0)mi."
    self.humidityString = "\(Int((beachForecast.forecast?.currently.humidity ?? 0) * 100))%"
    self.colors = beachForecast.forecast?.currently.icon.toColor ?? [.white, .white]
  }
  
}
