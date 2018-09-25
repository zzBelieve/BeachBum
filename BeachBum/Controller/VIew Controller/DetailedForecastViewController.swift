//
//  DetailedForecastViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/13/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
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
  private var navBar: UINavigationBar? {  return navigationController?.navigationBar }
  private var hourlyForecastViewController: HourlyForecastViewController? {
    didSet {
      hourlyForecastViewController?.hourlyForecast = self.beachForecast?.forecast?.hourly
      hourlyForecastViewController?.delegate = self
      hourlyForecastViewController?.borderColor = beachForecast?.forecast?.currently.icon.toColor.first ?? .white
    }
  }
  
  @IBOutlet var detailedForecastView: DetailedForecastView!
  
  //MARK: Drawer View Constraints and variables
  @IBOutlet weak var drawerView: UIView!
  @IBOutlet weak var drawerViewBottomConstraint: NSLayoutConstraint!
  private var drawerViewHidden = true
  var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))
}

//MARK: View Lifecycle
extension DetailedForecastViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
    configureNavbar()
    addSwipGesture()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
}

//MARK: UI, Navbar configuration, and Swipe gesture
extension DetailedForecastViewController {
  private func updateUI() {
    guard let beachForecast = beachForecast else { return }
    detailedForecastView.model = DetailedForecastViewModel(beachForecast, distanceFromUser ?? 00)
  }
  
  private func configureNavbar() {
//    if let navBar = navigationController?.navigationBar {
//      navBar.isTranslucent = false
//      navBar.setBackgroundImage(UIImage(), for: .default)
//      navBar.shadowImage = UIImage()
//      navBar.barTintColor = UIColor.init(gradientStyle: .leftToRight, withFrame: navBar.frame, andColors: gradientColorArray ?? [.white])
//      navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: accentColors?.first ?? .black, isFlat: true)
//    }
//    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = beachForecast?.beach.name
    if let navBar = navigationController?.navigationBar {
      navBar.tintColor = gradientColorArray?.last ?? .black
      navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: accentColors?.last ?? .black, NSAttributedStringKey.font: UIFont(name: "Nunito-ExtraBold", size: 40.0)!]
    }
  }
  
  private func addSwipGesture() {
    swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToToggleExpansion(_:)))
    swipeGesture.direction = drawerViewHidden ? .up : .down
    self.view.addGestureRecognizer(swipeGesture)
  }
}

//MARK: Navigation
extension DetailedForecastViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Hourly Forecast" {
      hourlyForecastViewController = segue.destination as? HourlyForecastViewController
    }
  }
}

//MARK: Drawer View Delegate and Methods
extension DetailedForecastViewController: HourlyForecastViewControllerDelegate {

  private func toggleDrawerViewExpansion() {
    let amountToMove = drawerView.bounds.height * 0.70
    let initialConstraint = drawerViewBottomConstraint.constant
    let newConstraint = initialConstraint + (drawerViewHidden ? amountToMove : -amountToMove)
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
      self.drawerViewBottomConstraint.constant = newConstraint
      self.view.layoutIfNeeded()
    })
    drawerViewHidden = !drawerViewHidden
    self.view.removeGestureRecognizer(swipeGesture)
    addSwipGesture()
  }
  
  //Delegate method from HourlyForecastViewControllerDelegate Protocol
  func toggleExpansionPressed() {
    toggleDrawerViewExpansion()
  }
  
  @objc private func swipeToToggleExpansion(_ recognizer: UISwipeGestureRecognizer) {
    switch recognizer.state {
    case .began, .changed, .ended:
      toggleDrawerViewExpansion()
    default: break
    }
  }
}
