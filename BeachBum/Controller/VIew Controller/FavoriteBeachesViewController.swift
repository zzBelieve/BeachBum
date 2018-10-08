//
//  FavoriteBeachesViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/18/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD

class FavoriteBeachesViewController: ForecastsViewController {
  
  @IBOutlet weak var addFavoriteBeachesNoticeView: UIView!
  
  override func retrieveBeaches() {
    //TODO retrieve data from the storage controller
    print("in retrieve beaches")
    guard let favoriteBeaches = storageController.loadData() else { print("no favorite beaches"); SVProgressHUD.dismiss(); return }
    self.favoriteBeaches = favoriteBeaches
    addFavoriteBeachesNoticeView.isHidden = !favoriteBeaches.isEmpty
    fetchForecasts(for: self.favoriteBeaches)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addFavoriteBeachesNoticeView.isHidden = !favoriteBeaches.isEmpty
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
