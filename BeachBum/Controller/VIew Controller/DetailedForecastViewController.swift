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
    let stringDate = dateFormatter.string(from: date)
    print(stringDate)
    return dateFormatter.string(from: date)
  }
  
  //MARK: Outlets
  @IBOutlet var detailedForecastView: DetailedForecastView!
  
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  @IBOutlet weak var currentSummaryLabel: UILabel!
  @IBOutlet weak var currentWeatherImageView: UIImageView!
  @IBOutlet weak var sunriseTimeLabel: UILabel!
  @IBOutlet weak var sunsetTimeLabel: UILabel!
  @IBOutlet weak var windSpeed: UILabel!
  @IBOutlet weak var chanceOfRainLabel: UILabel!
  @IBOutlet weak var apparentTemperatureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  
  
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    beachNameLabel?.text = beachForecast.beach.name
    currentTemperatureLabel?.text = beachForecast.forecast!.currently.temperature.temperatureFormatted
    currentSummaryLabel?.text = beachForecast.forecast!.currently.summary
    sunriseTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunriseTime)
    sunsetTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunsetTime)
    windSpeed?.text = "\(Int(beachForecast.forecast!.currently.windSpeed))mph"
    chanceOfRainLabel?.text = "\(Int((beachForecast.forecast?.daily?.data.first?.precipProbability ?? 0) * 100))%"
    apparentTemperatureLabel?.text = beachForecast.forecast!.currently.apparentTemperature.temperatureFormatted
    humidityLabel?.text = "\(Int(beachForecast.forecast!.currently.humidity * 100))%"
    if let iconString = beachForecast.forecast?.currently.icon {
      if let image = UIImage(named: iconString) {
        currentWeatherImageView?.image = image
      }
    }
    
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    //provideMockData()
  }
  
  private func provideMockData() {
    let mockData = MockData()
    beachForecast = mockData.beachForecasts.first!
  }
}
