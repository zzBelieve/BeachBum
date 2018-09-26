//
//  BeachForecastsView.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/5/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit
import ChameleonFramework

protocol BeachForecastsViewDelegate: class {
  func sortButtonPressed(_ sortType: Sort)
}

class BeachForecastsView: UIView {
  @IBOutlet weak var sortButtonsViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var sortButtonsView: UIView! {
    didSet {
      sortButtonsView?.backgroundColor = UIColor.flatSkyBlue
      sortButtonsView?.layer.cornerRadius = sortButtonsView.frame.size.height / 2
    }
  }
  
  @IBOutlet weak var popupView: UIView! {
    didSet {
      popupView.layer.cornerRadius = popupView.frame.size.width / 2
      popupView?.clipsToBounds = true
    }
  }
  
  @IBOutlet weak var popupLabel: UILabel!
  weak var delegate: BeachForecastsViewDelegate?
  private var sortButtonExpanded = false
  
  @IBOutlet var sortOptionButtons: [UIButton]! { didSet {    configureButtons() } }
  
  @IBAction func sortOptionButtonPressed(_ sender: UIButton) {
    if let index = sortOptionButtons.index(of: sender) {
      delegate?.sortButtonPressed(Sort.all[index])
    }
  }
  
  @IBOutlet weak var sortButton: UIButton! {
    didSet {
      let width = sortButton.frame.width
      sortButton.layer.cornerRadius = width / 2
      sortButton.backgroundColor = .flatSkyBlue
      if let image = UIImage(named: "sort") {
        sortButton.setImage(image, for: .normal)
      }
      let number = 10
      sortButton.imageEdgeInsets = UIEdgeInsetsMake(CGFloat(number), CGFloat(number), CGFloat(number), CGFloat(number))
      sortButton.clipsToBounds = true
    }
  }
  
  @IBAction func sortButtonPressed(_ sender: UIButton) { toggleSortBarExpansion() }
  
  private func toggleSortBarExpansion() {
    sortButton.isEnabled = false
    let expandedWidth = sortButton.frame.size.width * CGFloat(sortOptionButtons.count + 1)
    if self.sortButtonExpanded {
      self.sortButtonsViewWidthConstraint.constant = 50
    } else {
      self.sortButtonsViewWidthConstraint.constant = expandedWidth
    }
    
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: { [weak self] in
      self!.layoutIfNeeded()
      for index in 0..<self!.sortOptionButtons.count {
        if self!.sortButtonExpanded {
          self!.sortOptionButtons[index].transform = CGAffineTransform.identity
          self!.sortOptionButtons[index].alpha = 0.0
        } else {
          let x = (self!.sortButton?.frame.size.width ?? 0) * CGFloat(index + 1)
          self!.sortOptionButtons[index].transform = CGAffineTransform(translationX: -x, y: 0.0)
          self!.sortOptionButtons[index].alpha = 1.0
          self!.sortOptionButtons[index].isHidden = false
        }
      }
    }) { completion in
      self.sortButton.isEnabled = true
    }
    sortButtonExpanded = !sortButtonExpanded
  }
  
  func configureButtons() {
    for index in 0..<sortOptionButtons.count {
      let button = sortOptionButtons[index]
      let width = button.frame.width
      button.layer.cornerRadius = width / 2
      button.clipsToBounds = true
      button.backgroundColor = .clear
      let sortType = Sort.all[index]
      if let image = UIImage(named: sortType.rawValue) {
        button.setImage(image, for: .normal)
      }
      sortOptionButtons[index].imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
    }
  }
  
  func showPopupView(with text: String) {
    popupLabel?.text = text
    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 2.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
      self.bringSubview(toFront: self.popupView)
      self.layoutSubviews()
      self.popupView.alpha = 1.0
    }, completion: { _ in
      UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .allowUserInteraction, animations: {
        self.popupView.alpha = 0.0
      })
    })
  }
}

enum Sort: String, RawRepresentable {
  case temperature
  case weatherCondition
  case distance
  static var all: [Sort] {
    return [Sort.temperature, .weatherCondition, .distance]
  }
}
