//
//  BeachForecastsView.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/5/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

protocol BeachForecastsViewDelegate: class {
  func sortButtonPressed(_ sortType: Sort)
}

class BeachForecastsView: UIView {
  
  weak var delegate: BeachForecastsViewDelegate?
  private var sortButtonExpanded = false
  
  @IBOutlet var sortOptions: [UIButton]! {
    didSet {
      configureButtons()
    }
  }
  
  @IBAction func sortOptionButtonPressed(_ sender: UIButton) {
    if let index = sortOptions.index(of: sender) {
      delegate?.sortButtonPressed(Sort.all[index])
    }
  }
  
  
  @IBOutlet weak var sortButton: UIButton! {
    didSet {
      let width = sortButton.frame.width
      sortButton.layer.cornerRadius = width / 2
      sortButton.clipsToBounds = true
    }
  }
  
  @IBAction func sortButtonPressed(_ sender: UIButton) {
    toggleSortBarExpansion()
  }
  
  private func toggleSortBarExpansion() {
    sortButton.isEnabled = false
    if sortButtonExpanded { sortOptions.forEach { $0.center.x = sortButton.center.x } }
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: { [weak self] in
      for index in 0..<self!.sortOptions.count {
        if self!.sortButtonExpanded {
          self!.sortOptions[index].transform = CGAffineTransform.identity
          self!.sortOptions[index].alpha = 0.0
        } else {
          let x = (self!.sortButton?.frame.size.width ?? 0) * CGFloat(index + 1)
          self!.sortOptions[index].transform = CGAffineTransform(translationX: -x, y: 0.0)
          self!.sortOptions[index].alpha = 1.0
          self!.sortOptions[index].isHidden = false
        }
      }
    }) { completion in
      self.sortButton.isEnabled = true
    }
    sortButtonExpanded = !sortButtonExpanded
  }
  
  func configureButtons() {
    for index in 0..<sortOptions.count {
      let button = sortOptions[index]
      let width = button.frame.width
      button.layer.cornerRadius = width / 2
      button.clipsToBounds = true
      let sortType = Sort.all[index]
      if let image = UIImage(named: sortType.rawValue) {
        button.setImage(image, for: .normal)
      }
    }
  }
}

enum Sort: String, RawRepresentable {
  case alphabetical
  case side
  case temperature
  case weatherCondition
  
  static var all: [Sort] {
    return [Sort.alphabetical, .side, .temperature, .weatherCondition]
  }
}
