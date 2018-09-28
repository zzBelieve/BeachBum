//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//
//
import UIKit
import ChameleonFramework
import SVProgressHUD

class BeachForecastsViewController: ForecastsViewController {
  
  override func retrieveBeaches() {
    networkController.fetchData(completion: { [weak self] in
      self?.fetchForecasts(for: $0, completion: { [weak self] in
        self?.beachForecastController._beachForecastsArray = $0
        self?.forecastTableView?.reloadSections([0], with: .automatic)
        SVProgressHUD.dismiss()
      })
    })
    //addMockData()
  }
  
  //table view leading swipe action
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let beach = beachForecastController.beachForecastForIndexAt(indexPath.row).beach
    let leadingSwipeAction = UIContextualAction(style: .normal, title: "Add To Favorites") { (action, view, completion) in
      if self.favoriteBeaches.contains(where: { $0.name == beach.name} ) {
        self.forecastsView.showPopupView(with: "Already in favorites")
        completion(false)
      } else {
        self.favoriteBeaches.append(beach)
        self.storageController.saveData(self.favoriteBeaches)
        self.forecastsView.showPopupView(with: "Added")
        completion(true)
      }
    }
    leadingSwipeAction.backgroundColor = .flatMint
    return UISwipeActionsConfiguration(actions: [leadingSwipeAction])
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    return UISwipeActionsConfiguration(actions: [])
  }
}
