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

  var favoriteBeaches = [Beach]()
  var storageController = StorageController()
  
  override func retrieveBeaches() {
    //TODO retrieve data from the storage controller
    guard let favoriteBeaches = storageController.loadData() else { print("error loading beaches"); return }
    self.favoriteBeaches = favoriteBeaches
    fetchForecasts(for: self.favoriteBeaches)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
    switch editingStyle {
    case .delete:
      //remove from beach forecasts
      let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
      beachForecastController.removeBeach(at: indexPath.row)
      //remove from beachforecast table view
      forecastTableView?.deleteRows(at: [indexPath], with: .automatic)
      storage(willDeleteBeachFrom: beachForecast)
    default: break
    }
  }
}

extension FavoriteBeachesViewController: StorageDelegate {
  func storage(willAddBeachFrom beachForecast: BeachForecast) {
    guard !favoriteBeaches.contains(where: { $0.name == beachForecast.beach.name }) else { print("beach exists in array"); return }
    favoriteBeaches.append(beachForecast.beach)
    storageController.saveData(favoriteBeaches)
    if let loadedBeaches = storageController.loadData() { favoriteBeaches = loadedBeaches }
    beachForecastController.addBeachForecast(beachForecast)
    forecastTableView?.reloadSections([0], with: .automatic)
  }
  
  func storage(willDeleteBeachFrom beachForecast: BeachForecast) {
    //remove from favorite beaches
    if let index = favoriteBeaches.index(where: { $0.name == beachForecast.beach.name }) { favoriteBeaches.remove(at: index) }
    //call storageController to save new array
    storageController.saveData(favoriteBeaches)
    if let loadedBeaches = storageController.loadData() { favoriteBeaches = loadedBeaches }
  }
}
