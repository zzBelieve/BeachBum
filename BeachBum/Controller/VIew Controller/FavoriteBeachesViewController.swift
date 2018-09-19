//
//  FavoriteBeachesViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/18/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class FavoriteBeachesViewController: BeachForecastsViewController {

  
  override func retrievedata() {
    //TODO retrieve data from the storage controller
    let beaches = StorageController.favoriteBeaches
    fetchForecasts(for: beaches)
  }
  
  func addBeachForecast(_ beachForecast: BeachForecast) {
    //TODO: tell storage controller to add to favorite beaches
    storageController.addToBeaches(beachForecast.beach)
    //add the beachforecast to the beachForecasts
    beachForecastController.addBeachForecast(beachForecast)
    //reload sections for the tableview
    beachForecastTableView?.reloadData()
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
    switch editingStyle {
    case .delete:
      //TODO
      //remove from favorite beaches
      storageController.removeBeach(beachForecast.beach)
      //remove from beach forecasts
      beachForecastController.removeBeach(beachForecast)
      //remove from beachforecast table view
      beachForecastTableView?.deleteRows(at: [indexPath], with: .automatic)
    default: break
    }
  }
  
  override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return UISwipeActionsConfiguration(actions: [])
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return nil
  }
  
}
