//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//
//
import UIKit
import Firebase
import CoreLocation
import ChameleonFramework

class BeachForecastsViewController: ForecastsViewController {
  
  override func retrieveBeaches() {
    print("calling retrieveBeachNames to retrieve beaches from Firebase")
    beachForecastController.retrieveBeachNames { [weak self] in
      self?.fetchForecasts(for: $0)
    }
    //addMockData()
  }
  
  //table view leading swipe action
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let beach = beachForecastController.beachForecastForIndexAt(indexPath.row).beach
    let leadingSwipeAction = UIContextualAction(style: .normal, title: "Add To Favorites") { (action, view, completion) in
      guard !self.favoriteBeaches.contains(where: { $0.name == beach.name} ) else { print("beach exists"); completion(false); return }
      self.favoriteBeaches.append(beach)
      self.storageController.saveData(self.favoriteBeaches)
      completion(true)
    }
    leadingSwipeAction.backgroundColor = .flatMint
    return UISwipeActionsConfiguration(actions: [leadingSwipeAction])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return UISwipeActionsConfiguration(actions: [])
  }
}
