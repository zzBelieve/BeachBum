//
//  DetailedForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/13/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class DetailedForecastViewController: UIViewController {
  
  var beachForecast: BeachForecast?
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    formatter.timeZone = TimeZone(abbreviation: "HST")
    return formatter
  }()
  
  private func timeToString(withSeconds seconds: Int?) -> String? {
    guard let seconds = seconds else { print("seconds not avail"); return nil }
    let date = Date(timeIntervalSince1970: TimeInterval(seconds))
    return dateFormatter.string(from: date)
  }
  
  //MARK: Outlets
  @IBOutlet var detailedForecastView: DetailedForecastView!
  
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    guard let dfView = detailedForecastView else { print("no detailed forecast view"); return }
    dfView.beachNameLabel?.text = beachForecast.beach.name
    dfView.currentTemperatureLabel?.text = beachForecast.forecast!.currently.temperature.temperatureFormatted
    dfView.currentSummaryLabel?.text = beachForecast.forecast!.currently.summary
    dfView.sunriseTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunriseTime)
    dfView.sunsetTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunsetTime)
    dfView.windSpeed?.text = "\(Int(beachForecast.forecast!.currently.windSpeed))mph"
    dfView.chanceOfRainLabel?.text = "\(Int((beachForecast.forecast?.daily?.data.first?.precipProbability ?? 0) * 100))%"
    dfView.apparentTemperatureLabel?.text = beachForecast.forecast!.currently.apparentTemperature.temperatureFormatted
    dfView.humidityLabel?.text = "\(Int(beachForecast.forecast!.currently.humidity * 100))%"
    if let iconString = beachForecast.forecast?.currently.icon {
      if let image = UIImage(named: iconString) {
        dfView.currentWeatherImageView?.image = image
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    self.detailedForecastView?.bottomView.transform = CGAffineTransform(translationX: 0.0, y: 1000)
    UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
      self.detailedForecastView?.bottomView.transform = CGAffineTransform.identity
    })
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
}
