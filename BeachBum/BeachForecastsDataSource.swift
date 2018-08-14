//
//  BeachForecastsDataSource.swift
//  JSON Weather
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class BeachForecastsDataSource: NSObject {
  
  var beachForecastController: BeachForecastController
  
  init(_ beachForecastController: BeachForecastController) {
    self.beachForecastController = beachForecastController
  }
  
}

extension BeachForecastsDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeachCell", for: indexPath)
    guard let beachCell = cell as? BeachForecastCollectionViewCell else { return cell }
    beachCell.model = BeachForecastCollectionViewCell.Model(beach: beachForecastController.beaches[indexPath.item])
    return cell
  }
}
