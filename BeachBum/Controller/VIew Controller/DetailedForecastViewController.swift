//
//  DetailedForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/13/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class DetailedForecastViewController: UIViewController {
  
  var beachForecast: BeachForecast? {
    didSet {
     updateUI()
    }
  }
  
  @IBOutlet weak var beachNameLabel: UILabel!
  @IBOutlet weak var currentTemperatureLabel: UILabel!
  
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    beachNameLabel?.text = beachForecast.beach.name
    currentTemperatureLabel?.text = String(beachForecast.forecast!.currently.temperature)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //updateUI()
    provideMockData()
  }
  
  private func provideMockData() {
    let beach = Beach(name: "Haleiwa", side: "North", latitude: 21.5928, longitude: -158.1034)
    let currently = Forecast.Currently(summary: "Parly Cloudy",
                                       icon: "clear-day",
                                       temperature: 84.40,
                                       apparentTemperature: 90.32)
    let haleiwaBeach = BeachForecast(beach: beach, forecast: Forecast(currently: currently, hourly: nil))
    beachForecast = haleiwaBeach
  }
}
