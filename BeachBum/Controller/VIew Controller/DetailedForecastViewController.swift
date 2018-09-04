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
    updateUI()
  }
}
