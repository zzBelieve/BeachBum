//
//  HourlyForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

protocol HourlyForecastViewControllerDelegate: class {
  func toggleExpansionPressed()
}

class HourlyForecastViewController: UIViewController {
  
  weak var delegate: HourlyForecastViewControllerDelegate?
  
  var hourlyForecast: Forecast.Hourly? {
    didSet {
      dataSource = HourlyForecastDataSource(hourlyForecast: hourlyForecast)
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
      hourlyForecastCollectionView?.backgroundColor = .clear
      hourlyForecastCollectionView?.layer.cornerRadius = 10.0
      hourlyForecastCollectionView?.dataSource = dataSource
    }
  }
  
  @IBAction func toggleCollapseButtonPressed(_ sender: UIButton) {
    delegate?.toggleExpansionPressed()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear

    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.layer.cornerRadius = 10.0
    blurView.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(blurView, at: 0)
    NSLayoutConstraint.activate([
      blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
      blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
      ])
  }
  
}
