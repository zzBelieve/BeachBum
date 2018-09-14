//
//  BeachForecastTableViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/4/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import CoreLocation
import ChameleonFramework

class BeachForecastTableViewCell: UITableViewCell {
  
  //MARK: Outlets
  @IBOutlet private weak var container: UIView! {
    didSet {
      container.layer.cornerRadius = 8.0
      container.clipsToBounds = true
    }
  }
  @IBOutlet private weak var accentColorview: UIView!
  @IBOutlet private weak var beachNameLabel: UILabel!
  @IBOutlet private weak var sideOfIslandLabel: UILabel!
  @IBOutlet private weak var summaryLabel: UILabel!
  @IBOutlet private weak var weatherIconImageView: UIImageView!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var distanceLabel: UILabel!
  
  //MARK: Property observers set from the data source
  var accentColor: UIColor? { didSet { accentColorview?.backgroundColor = accentColor}}
  var distanceFromUser: Int? {didSet { distanceLabel?.text = "\(distanceFromUser ?? 0) mi." } }
  var beachName: String? { didSet { beachNameLabel?.text = beachName } }
  var sideOfIsland: String? { didSet { sideOfIslandLabel?.text = "\(sideOfIsland ?? "--") side" } }
  var summary: String? { didSet { summaryLabel?.text = summary } }
  var temperature: Int? { didSet { temperatureLabel?.text = "\(temperature ?? 0)°"}}
  var iconString: String? {
    didSet {
      if let image = UIImage(named: iconString!) {
        weatherIconImageView.image = image
      }
    }
  }
}

