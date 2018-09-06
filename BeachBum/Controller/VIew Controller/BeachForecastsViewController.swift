//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout, BeachForecastsViewDelegate {
  
  //Mock Data for testing
  let mockData = MockData()
  
  let refresher = UIRefreshControl()
  
  //MARK: Injected Objects
  var beachForecastController = BeachForecastController()
  private var dataSource: BeachForecastsDataSource? {
    didSet {
      beachForecastTableView?.dataSource = dataSource
      beachForecastTableView?.reloadSections([0], with: .fade)
    }
  }
  
  @IBOutlet weak var beachForecastTableView: UITableView! {
    didSet {
      beachForecastTableView.delegate = self
      beachForecastTableView.register(UINib(nibName: "BeachForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "Beach Cell")
      refresher.addTarget(self, action: #selector(refreshForecasts), for: .valueChanged)
      beachForecastTableView.refreshControl = refresher
      
    }
  }

  @IBOutlet var beachForecastsView: BeachForecastsView! {
    didSet {
      beachForecastsView.delegate = self
    }
  }
  
  func sortButtonPressed(_ sortType: Sort) {
    beachForecastController.sortBeachForecasts(sortType)
    dataSource = BeachForecastsDataSource(beachForecastController)
  }
  
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    beachForecastController.updateForecasts { [weak self] in
      print("forecast has been finished updating")
      print("setting the data source")
      self?.dataSource = BeachForecastsDataSource(self!.beachForecastController)
    }
    beachForecastTableView.refreshControl?.endRefreshing()
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
//    print("calling retrievBeachNames to retrieve beaches from Firebase")
//    beachForecastController.retrieveBeacheNames { [weak self] in
//      print("calling fetchForecast to obtain forecast for all beaches")
//      self?.beachForecastController.updateForecasts { [weak self] in
//        print("forecast has been finished updating")
//        print("setting the data source")
//        self?.dataSource = BeachForecastsDataSource(self!.beachForecastController)
//      }
//    }
    beachForecastController.beachForecasts = mockData.beachForecasts
    dataSource = BeachForecastsDataSource(beachForecastController)
  }
}

extension BeachForecastsViewController: UITableViewDelegate {
  
  
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Beach" {
      //TODO segue from table view cell
    }
  }
}
