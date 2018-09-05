//
//  FormattingData.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

extension Double {
  var twoDecimalPoints: String {
    return String(format: "%.2f", self)
  }
}
