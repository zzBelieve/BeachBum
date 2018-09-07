//
//  HourlyForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class HourlyForecastViewController: UIViewController, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyForecast?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hourly Forecast Cell", for: indexPath)
    guard let hourlyCell = cell as? HourlyForecastCollectionViewCell  else { print("not able to set as hourly cell"); return cell}
    hourlyCell.hourlyData = hourlyForecast!.data[indexPath.item]
    return cell
  }
  
  
  var hourlyForecast: Forecast.Hourly? {
    didSet {
      dataSource = HourlyForecastDataSource(hourlyForecast: hourlyForecast!)
    }
  }
  var dataSource: HourlyForecastDataSource? {
    didSet {
      print("setting the data source")
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
    //hourlyForecastCollectionView?.reloadData()
  }
  
}
