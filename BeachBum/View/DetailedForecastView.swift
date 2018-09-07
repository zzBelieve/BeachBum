//
//  DetailedForecastView.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/6/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class DetailedForecastView: UIView {
  
  @IBOutlet weak var bottomView: UIView! {
    didSet {
      bottomView.layer.cornerRadius = bottomView.frame.size.width / 2
    }
  }
  @IBOutlet weak var detailsView: UIView! {
    didSet {
      detailsView.layer.cornerRadius = 10.0
    }
  }
}

