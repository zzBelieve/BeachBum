//
//  HourlyForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class HourlyForecastViewController: UIViewController {
  var hourlyForecast: Forecast.Hourly? {
    didSet {
      dataSource = HourlyForecastDataSource(hourlyForecast: hourlyForecast!)
    }
  }
  var dataSource: HourlyForecastDataSource? {
    didSet {
      hourlyForecastCollectionView?.dataSource = dataSource!
      hourlyForecastCollectionView?.reloadData()
    }
  }
  
  @IBOutlet var hourlyForecastView: UIView! {
    didSet {
      hourlyForecastView.layer.cornerRadius = 10.0
    }
  }
  
  @IBOutlet weak var hourlyForecastCollectionView: UICollectionView! {
    didSet {
        hourlyForecastCollectionView?.dataSource = dataSource
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
