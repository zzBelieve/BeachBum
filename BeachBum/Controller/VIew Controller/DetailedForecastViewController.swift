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
  private var hourlyForecastViewController: HourlyForecastViewController? {
    didSet {
      hourlyForecastViewController?.hourlyForecast = self.beachForecast?.forecast?.hourly
      hourlyForecastViewController?.delegate = self
    }
  }
  
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
  
  //MARK: Container View Constraints
  private var containerViewHidden = false
  @IBOutlet weak var containerViewHeight: UIView!
  @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
  var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))

  
  
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
    self.detailedForecastView?.bottomView.transform = CGAffineTransform(translationX: 0.0, y: 1000)
    UIView.animate(withDuration: 0.6, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
      self.detailedForecastView?.bottomView.transform = CGAffineTransform.identity
    })
    toggleContainerViewCollapse(initial: true)
    addSwipGesture()
    updateUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Hourly Forecast" {
      hourlyForecastViewController = segue.destination as? HourlyForecastViewController
      
    }
  }
}

//MARK: Container View Delegate and Methods
extension DetailedForecastViewController: HourlyForecastViewControllerDelegate {
  
  private func toggleContainerViewCollapse(initial: Bool = false) {
    let height = containerViewHeight.bounds.height * (initial ? 0.90 : 0.50)
    let initialConstraint = containerViewBottomConstraint.constant
    let newConstraint = containerViewHidden ? (height + initialConstraint) : (initialConstraint - height)
    if initial {
      containerViewBottomConstraint.constant = newConstraint
      view.layoutIfNeeded()
    } else {
      UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
        self.containerViewBottomConstraint.constant = newConstraint
        self.view.layoutIfNeeded()
      })
    }
    containerViewHidden = !containerViewHidden
    self.view.removeGestureRecognizer(swipeGesture)
    addSwipGesture()
  }
  
  func toggleExpansionPressed() {
    toggleContainerViewCollapse()
  }
  
  private func addSwipGesture() {
    swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))
    swipeGesture.direction = containerViewHidden ? .up : .down
    self.view.addGestureRecognizer(swipeGesture)
  }
  
  @objc private func swipeToToggleExpansion(_ recognizer: UISwipeGestureRecognizer) {
    switch recognizer.state {
    case .began, .changed, .ended:
      toggleContainerViewCollapse()
    default: break
    }
  }
}
