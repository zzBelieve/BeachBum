//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
//import ChameleonFramework

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout, BeachForecastsViewDelegate {
  
  //Mock Data for testing
  let mockData = MockData()
  
  let refresher = UIRefreshControl()
  
  //MARK: Injected Objects
  var beachForecastController = BeachForecastController()
  private var dataSource: BeachForecastsDataSource? {
    didSet {
      print("datasource has been set")
      beachForecastTableView?.dataSource = dataSource
      beachForecastTableView?.reloadSections([0], with: .fade)
    }
  }
  
  @IBOutlet weak var beachForecastTableView: UITableView! {
    didSet {
      beachForecastTableView?.backgroundColor = UIColor.flatWhite
      //beachForecastTableView?.backgroundColor = UIColor(gradientStyle: .diagonal, withFrame: (beachForecastTableView?.frame)!, andColors: [.flatSand, .flatSandDark])
      beachForecastTableView.delegate = self
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
//    print("refreshing location")
//    beachForecastController.configureLocationManager()
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
    NotificationCenter.default.addObserver(forName: .UserLocationObserver,
                                           object: self.beachForecastController,
                                           queue: OperationQueue.main) { (_) in
                                            print("loation has been observed")
                                            self.dataSource = BeachForecastsDataSource(self.beachForecastController)
    }
    beachForecastController.configureLocationManager()
    //beachForecastController.beachForecasts = mockData.beachForecasts; dataSource = BeachForecastsDataSource(beachForecastController)
    retrievedata()
    
  }
  
  private func retrievedata() {
    print("calling retrievBeachNames to retrieve beaches from Firebase")
    beachForecastController.retrieveBeacheNames { [weak self] in
      print("calling fetchForecast to obtain forecast for all beaches")
      self?.beachForecastController.updateForecasts { [weak self] in
        print("forecast has been finished updating")
        print("setting the data source")
        self?.dataSource = BeachForecastsDataSource(self!.beachForecastController)
      }
    }
  }
}

extension BeachForecastsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    beachForecastTableView?.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
  }
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Detailed Forecast" {
      guard let detailedForecastVC = segue.destination as? DetailedForecastViewController else { print("not a detailed VC"); return }
      guard let indexPath = beachForecastTableView?.indexPathForSelectedRow else { print("no row selected"); return }
      let beachForecast = beachForecastController.beachForecasts[indexPath.row]
      detailedForecastVC.beachForecast = beachForecast
    }
  }
}
