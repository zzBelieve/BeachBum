//
//  BeachForecastsView.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/5/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class BeachForecastsView: UIView {
  
  
  
  func configureButtons(_ buttons: [UIButton]) {
    for index in 0..<buttons.count {
      let button = buttons[index]
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
  
  static var all: [Sort] {
    return [Sort.alphabetical, .side, .temperature]
  }
}

//
////@IBOutlet weak var sortBar: UIView!
//@IBOutlet var sortOptions: [UIButton]! {
//  didSet {
//    sortOptions.forEach {
//      let width = $0.frame.width
//      $0.layer.cornerRadius = width / 2
//      $0.clipsToBounds = true
//    }
//  }
//}
//
//private var sortButtonExpanded = false
//private var alphaSorted = false
//private var tempSorted = false
//private var regionSorted = false
//@IBAction func sortButtonPressed(_ sender: UIButton) {
//  toggleSortBarExpansion()
//}
//
//private func toggleSortBarExpansion() {
//  sortButton.isEnabled = false
//  for index in 0...sortOptions.count - 1 {
//    if sortButtonExpanded {
//      UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
//        self.sortOptions[index].transform = CGAffineTransform.identity
//        self.sortOptions[index].alpha = 0.0
//        //self.alphabeticalSortButton.isHidden = true
//      }) { completion in
//        self.alphabeticalSortButton.isHidden = true
//        self.sortButton.isEnabled = true
//      }
//    } else {
//      sortOptions[index].center.x = sortButton.center.x
//      sortOptions[index].center.y = sortButton.center.y
//      UIView.animate(withDuration: 0.60, delay: 0.0, usingSpringWithDamping: 0.60, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
//        let x = (self.sortButton?.frame.size.width ?? 0) * CGFloat(index + 1)
//        self.sortOptions[index].transform = CGAffineTransform(translationX: -x, y: 0.0)
//        self.sortOptions[index].alpha = 1.0
//        self.sortOptions[index].isHidden = false
//      }) { completion in
//        self.sortButton.isEnabled = true
//      }
//    }
//  }
//
//  sortButtonExpanded = !sortButtonExpanded
//}
