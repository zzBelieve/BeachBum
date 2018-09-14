//
//  DetailedForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/13/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import CoreLocation
import ChameleonFramework

class DetailedForecastViewController: UIViewController {
  
  var beachForecast: BeachForecast?
  var distanceFromUser: Int?
  
  private var navBar: UINavigationBar? {
    return navigationController?.navigationBar
  }
  
  private var hourlyForecastViewController: HourlyForecastViewController? {
    didSet {
      hourlyForecastViewController?.hourlyForecast = self.beachForecast?.forecast?.hourly
      hourlyForecastViewController?.delegate = self
      hourlyForecastViewController?.borderColor = accentColor
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
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
  var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))

  @IBOutlet weak var topColoredView: UIView! {
    didSet {
      //topColoredView?.backgroundColor = accentColor
    }
  }
  
  
  private var accentColor: UIColor {
    switch beachForecast?.forecast?.currently.icon {
    case "clear-day": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors: [.flatSkyBlue, .flatSkyBlue, .flatSkyBlueDark, .flatSkyBlueDark])
      
    case "rain": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors: [.flatBlue, .flatBlue, .flatBlueDark, .flatBlueDark])
      
    case "partly-cloudy-day", "cloudy": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors:
      [.flatPowderBlue, .flatPowderBlue, .flatPowderBlueDark, .flatPowderBlueDark,])
      
    case "partly-cloudy-night": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors: [.flatPlum,.flatPlum,.flatPlumDark,.flatPlumDark])
      
    case "clear-night": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors: [.flatNavyBlue, .flatNavyBlue, .flatNavyBlueDark, .flatNavyBlueDark])
      
    case "wind": return UIColor(gradientStyle: .leftToRight, withFrame: topColoredView.bounds, andColors: [.flatMint, .flatMint, .flatMintDark, .flatMintDark])
      
    default: return .flatWhite
    }
  }
  
  
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    guard let dfView = detailedForecastView else { print("no detailed forecast view"); return }
    
    //Set Colors
    dfView.setThemeColorTo([accentColor])
    topColoredView?.backgroundColor = accentColor
    
    //Set the text
    dfView.beachNameLabel?.text = beachForecast.beach.name
    dfView.currentTemperatureLabel?.text = beachForecast.forecast!.currently.temperature.temperatureFormatted
    dfView.currentSummaryLabel?.text = beachForecast.forecast!.currently.summary
    dfView.sunriseTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunriseTime) ?? "00:00 pm"
    dfView.sunsetTimeLabel?.text = timeToString(withSeconds: beachForecast.forecast?.daily?.data.first?.sunsetTime) ?? "00:00 pm"
    dfView.windSpeed?.text = "\(Int(beachForecast.forecast!.currently.windSpeed))mph"
    dfView.chanceOfRainLabel?.text = "\(Int((beachForecast.forecast?.daily?.data.first?.precipProbability ?? 0) * 100))%"
    dfView.distanceLabel?.text = "\(distanceFromUser ?? 0)mi."
    dfView.humidityLabel?.text = "\(Int(beachForecast.forecast!.currently.humidity * 100))%"
    
    //Set the text color
    dfView.currentSummaryLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: accentColor, isFlat: true)
    dfView.beachNameLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: accentColor, isFlat: true)
    dfView.currentTemperatureLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: accentColor, isFlat: true)
    
    //Set icon image
    if let iconString = beachForecast.forecast?.currently.icon {
      if let image = UIImage(named: iconString) {
        dfView.currentWeatherImageView?.image = image
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    toggleContainerViewCollapse(initial: true)
    addSwipGesture()
    detailedForecastView?.circledWeatherIconView?.layer.borderColor = accentColor.cgColor
    updateUI()
    
    //Navigation bar configuration
    
    navBar?.isTranslucent = false
    navBar?.setBackgroundImage(UIImage(), for: .default)
    navBar?.shadowImage = UIImage()
    navBar?.barTintColor = accentColor
    navBar?.tintColor = UIColor(contrastingBlackOrWhiteColorOn: accentColor, isFlat: true)
    navigationItem.largeTitleDisplayMode = .never

  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navBar?.barTintColor = .white
    navBar?.setBackgroundImage(nil, for: .default)
    navBar?.shadowImage = nil
    navBar?.isTranslucent = true
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
    let height = containerView.bounds.height * (initial ? 0.90 : 0.70)
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
