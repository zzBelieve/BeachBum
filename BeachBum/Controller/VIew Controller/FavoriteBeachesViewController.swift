//
//  FavoriteBeachesViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/18/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import ChameleonFramework

class FavoriteBeachesViewController: ForecastsViewController {
  
  override func retrieveBeaches() {
    //TODO retrieve data from the storage controller
    guard let favoriteBeaches = storageController.loadData() else { print("error loading beaches"); return }
    self.favoriteBeaches = favoriteBeaches
    fetchForecasts(for: self.favoriteBeaches) { [weak self] in
      self?.beachForecastController.beachForecastsArray = $0
      self?.forecastTableView?.reloadSections([0], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
    switch editingStyle {
    case .delete:
      let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
      beachForecastController.removeBeach(at: indexPath.row)
      forecastTableView?.deleteRows(at: [indexPath], with: .automatic)
      storage(willDeleteBeachFrom: beachForecast)
    default: break
    }
  }
}

extension FavoriteBeachesViewController {
  func storage(willDeleteBeachFrom beachForecast: BeachForecast) {
    //remove from favorite beaches
    if let index = favoriteBeaches.index(where: { $0.name == beachForecast.beach.name }) {
      favoriteBeaches.remove(at: index)
      storageController.saveData(favoriteBeaches)
    }
  }
}
