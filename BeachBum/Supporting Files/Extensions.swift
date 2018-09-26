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

extension Int {
  func formatTimeAs(_ formatString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .none
    dateFormatter.dateFormat = formatString
    dateFormatter.timeZone = TimeZone(abbreviation: "HST")
    let date = Date(timeIntervalSince1970: TimeInterval(self))
    return dateFormatter.string(from: date)
  }
}

extension Notification.Name {
  static let UserLocationObserver = Notification.Name(rawValue: "UserLocationObserver")
}

