//
//  HourlyForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import ChameleonFramework
protocol HourlyForecastViewControllerDelegate: class {
  func toggleExpansionPressed()
}

class HourlyForecastViewController: UIViewController {
  
  weak var delegate: HourlyForecastViewControllerDelegate?
  
  var hourlyForecast: Forecast.Hourly?
  var borderColor: UIColor?
  
  @IBOutlet var hourlyForecastView: UIView! {
    didSet {
      hourlyForecastView.layer.cornerRadius = 10.0
    }
  }
  
  @IBOutlet weak var hourlyForecastCollectionView: UICollectionView! {
    didSet {
      hourlyForecastCollectionView?.backgroundColor = .clear
      hourlyForecastCollectionView?.layer.cornerRadius = 10.0
      hourlyForecastCollectionView?.dataSource = self
    }
  }
  
  @IBAction func toggleCollapseButtonPressed(_ sender: UIButton) {
    delegate?.toggleExpansionPressed()
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.cornerRadius = 30.0
    view.layer.masksToBounds = true
    view.layer.borderColor = borderColor?.cgColor
    view.layer.borderWidth = 2.0
    
    
    let blurEffect = UIBlurEffect(style: .extraLight)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false
    view.insertSubview(blurView, at: 0)
    NSLayoutConstraint.activate([
      blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
      blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
      ])
    
  }
}

//MARK: Data Source
extension HourlyForecastViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return hourlyForecast?.data.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Hourly Forecast Cell", for: indexPath)
    guard let hourlyCell = cell as? HourlyForecastCollectionViewCell  else { print("not able to set as hourly cell"); return cell}
    hourlyCell.hourlyData = hourlyForecast!.data[indexPath.item]
    return cell
  }
}
