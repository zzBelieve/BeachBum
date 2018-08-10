//
//  BeachForecastCollectionViewCell.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/10/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var beachCellView: UIView! {
    didSet {
      beachCellView?.backgroundColor = .lightBlue
      beachCellView?.layer.cornerRadius = 8.0
    }
  }
  
  
  var model: Model? {
    didSet {
      //guard let model = model else { return }
    }
  }
}


extension BeachForecastCollectionViewCell {
  
  struct Model {
    let beachName: String
    let temperature: Double
    
    init(beach: BeachForecast) {
      beachName = beach.name.rawValue
      temperature = beach.forecast.currently.temperature
    }
  }
}
