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

protocol StorageDelegate: class {
  func storage(willAddBeachFrom beachForecast: BeachForecast)
  func storage(willDeleteBeachFrom beachForecast: BeachForecast)
}

class BeachForecastsViewController: ForecastsViewController {
  
  weak var storageDelegate: StorageDelegate?
  var favoriteBeachesVC: FavoriteBeachesViewController? {
    guard let navCon = tabBarController?.viewControllers?.last as? UINavigationController else { print("not a navcon"); return nil }
    return navCon.viewControllers.first as? FavoriteBeachesViewController
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let favoriteBeachesVC = favoriteBeachesVC else { print("unable to find favoriteBeachesVC"); return }
    print("found a favoriteBeachesVC, making it my delegate")
    self.storageDelegate = favoriteBeachesVC
  }
  
  override func retrieveBeaches() {
    print("calling retrieveBeachNames to retrieve beaches from Firebase")
//    beachForecastController.retrieveBeachNames { [weak self] in
//      self?.fetchForecasts(for: $0)
//    }
    addMockData()
  }
  
  //delegate to tell favorite beaches to save favorite beaches
  
  //table view leading swipe action
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let beachForecast = beachForecastController.beachForecastForIndexAt(indexPath.row)
    let leadingSwipeAction = UIContextualAction(style: .normal, title: "Add To Favorites") { (action, view, completion) in
      self.storageDelegate?.storage(willAddBeachFrom: beachForecast)
      completion(true)
    }
    leadingSwipeAction.backgroundColor = .flatMint
    return UISwipeActionsConfiguration(actions: [leadingSwipeAction])
  }
}
