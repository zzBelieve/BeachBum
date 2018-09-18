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
  
  var model: BeachForecastCellViewModel? {
    didSet {
      guard let model = model else { return }
      accentColorview?.backgroundColor = model.colors
      beachNameLabel?.text = model.beachName
      sideOfIslandLabel?.text = model.sideOfIsland
      summaryLabel?.text = model.summary
      weatherIconImageView?.image = model.weatherImage
      temperatureLabel?.text = model.temperatureString
      distanceLabel?.text = model.distanceFromUserString
    }
  }
}

struct BeachForecastCellViewModel {
  var beachName: String
  var colors: UIColor
  var distanceFromUserString: String
  var sideOfIsland: String
  var summary: String
  var temperatureString: String
  var weatherImage: UIImage
  
  init(_ beachForecast: BeachForecast, _ distance: Int) {
    self.beachName = beachForecast.beach.name
    self.colors = beachForecast.forecast?.currently.icon.toColor.first ?? .white
    self.distanceFromUserString = "\(distance) mi."
    self.sideOfIsland = "\(beachForecast.beach.side) side"
    self.summary = beachForecast.forecast?.currently.summary ?? "---"
    self.temperatureString = "\(Int(beachForecast.forecast?.currently.temperature ?? 00))°"
    self.weatherImage = beachForecast.forecast?.currently.icon.toImage ?? UIImage()
  }
}
