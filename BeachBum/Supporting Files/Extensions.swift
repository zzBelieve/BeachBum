//
//  ThemeColors.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/10/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

//MARK: extensions for String gives color and image based off of icon string
extension String {
  var toColor: [UIColor] {
    switch self {
    case "clear-day": return [.flatSkyBlue, .flatSkyBlueDark]
    case "rain": return [.flatBlue, .flatBlueDark]
    case "partly-cloudy-day", "cloudy": return [.flatPowderBlue, .flatPowderBlueDark]
    case "partly-cloudy-night": return [.flatPlum, .flatPlumDark]
    case "wind": return [.flatMintDark, .flatMintDark]
    case "clear-night": return [.flatNavyBlue, .flatNavyBlueDark]
    default: return [.white, .white]
    }
  }
  
  var toImage: UIImage? {
    return UIImage(named: self)
  }
}

extension Double {
  var temperatureFormatted: String {
    return "\(String(format: "%.2f", self))°"
  }
}
