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
  
  var beachForecast: BeachForecast? {
    didSet {
      accentColors = beachForecast?.forecast?.currently.icon.toColor
    }
  }
  var distanceFromUser: Int?
  private var accentColors: [UIColor]?
  private var gradientColorArray: [UIColor]? {
    guard let firstColor = accentColors?.first, let secondColor = accentColors?.last else { return nil}
    return [firstColor, firstColor, secondColor, secondColor]
  }
  
  private var navBar: UINavigationBar? {
    return navigationController?.navigationBar
  }
  
  private var hourlyForecastViewController: HourlyForecastViewController? {
    didSet {
      hourlyForecastViewController?.hourlyForecast = self.beachForecast?.forecast?.hourly
      hourlyForecastViewController?.delegate = self
      hourlyForecastViewController?.borderColor = beachForecast?.forecast?.currently.icon.toColor.first ?? .white
    }
  }

  
  //MARK: Outlets
  @IBOutlet var detailedForecastView: DetailedForecastView!
  
  //MARK: Container View Constraints
  private var containerViewHidden = false
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
  var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))
  
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    guard let detailedForecastView = detailedForecastView else { print("no detailed forecast view"); return }
    
    //TODO: Send color to view so that view can configure
    detailedForecastView.mainColor = accentColors
    //Set the text
    detailedForecastView.beachName = beachForecast.beach.name
    detailedForecastView.temperature = beachForecast.forecast!.currently.temperature
    detailedForecastView.summary = beachForecast.forecast?.currently.summary
    detailedForecastView.imageIcon = beachForecast.forecast?.currently.icon
    detailedForecastView.sunriseTime = beachForecast.forecast?.daily?.data.first?.sunriseTime
    detailedForecastView.sunsetTime = beachForecast.forecast?.daily?.data.first?.sunsetTime
    detailedForecastView.windSpeed = beachForecast.forecast?.currently.windSpeed
    detailedForecastView.chanceOfRain = beachForecast.forecast?.daily?.data.first?.precipProbability
    detailedForecastView.distance = distanceFromUser
    detailedForecastView.humidity = beachForecast.forecast!.currently.humidity
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    toggleContainerViewCollapse(initial: true)
    addSwipGesture()
    updateUI()
    configureNavbar()
    

  }
  
  private func configureNavbar() {
    if let navBar = navigationController?.navigationBar {
      navBar.isTranslucent = false
      navBar.setBackgroundImage(UIImage(), for: .default)
      navBar.shadowImage = UIImage()
      navBar.barTintColor = UIColor.init(gradientStyle: .leftToRight, withFrame: navBar.frame, andColors: gradientColorArray ?? [.white])
      navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: accentColors?.first ?? .black, isFlat: true)
    }
   
    navigationItem.largeTitleDisplayMode = .never
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let navBar = navigationController?.navigationBar {
      navBar.barTintColor = .white
      navBar.setBackgroundImage(nil, for: .default)
      navBar.shadowImage = nil
      navBar.isTranslucent = true
    }
  }
}

extension DetailedForecastViewController {
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
