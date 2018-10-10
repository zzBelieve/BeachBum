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
  @IBOutlet var hourlyForecastView: UIView! { didSet { configureView() } }
  @IBOutlet weak var hourlyForecastCollectionView: UICollectionView! { didSet { configureCollectionView() } }
}

//MARK: View Lifecycle
extension HourlyForecastViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureBlurEffect()
  }
}

//MARK: UI Configuration
extension HourlyForecastViewController {
  
  private func configureCollectionView() {
    hourlyForecastCollectionView?.backgroundColor = .clear
    hourlyForecastCollectionView?.layer.cornerRadius = 10.0
    hourlyForecastCollectionView?.dataSource = self
  }
  
  private func configureView() {
    hourlyForecastView?.layer.cornerRadius = 30.0
    hourlyForecastView?.layer.masksToBounds = true
    hourlyForecastView?.layer.borderColor = borderColor?.cgColor
    hourlyForecastView?.layer.borderWidth = 2.0
  }
  
  private func configureBlurEffect() {
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
    guard let hourlyCell = cell as? HourlyForecastCollectionViewCell  else { return cell }
    guard let hourlyForecast = self.hourlyForecast?.data[indexPath.item] else { return hourlyCell }
    hourlyCell.model = HourlyForecastCellViewModel(hourlyForecast)
    return cell
  }
}

//MARK: Hourly Forecast View Controller Delegate Method
extension HourlyForecastViewController {
  @IBAction func toggleCollapseButtonPressed(_ sender: UIButton) {
    delegate?.toggleExpansionPressed()
  }
}
