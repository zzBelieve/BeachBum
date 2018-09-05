//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit
import Firebase

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  
  
  //Mock Data for testing
  let mockData = MockData()
  
  let refresher = UIRefreshControl()
  
  //MARK: Injected Objects
  var beachForecastController = BeachForecastController()
  private var dataSource: BeachForecastsDataSource? {
    didSet {
      beachForecastTableView?.dataSource = dataSource
      beachForecastTableView?.reloadData()
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
  
  @objc func refreshForecasts() {
    print("calling fetch forecast")
    beachForecastController.updateForecasts { [weak self] in
      print("forecast has been finished updating")
      print("setting the data source")
      self?.dataSource = BeachForecastsDataSource(self!.beachForecastController)
    }
    beachForecastTableView.refreshControl?.endRefreshing()
  }
  
  //MARK: Sort Buttons
  @IBOutlet weak var sortBar: UIView!
  @IBOutlet var sortOptions: [UIButton]! {
    didSet {
      sortOptions.forEach {
        let width = $0.frame.width
        $0.layer.cornerRadius = width / 2
        $0.clipsToBounds = true
      }
    }
  }
  
  private var sortButtonExpanded = false
  private var alphaSorted = false
  private var tempSorted = false
  private var regionSorted = false
  @IBAction func sortButtonPressed(_ sender: UIButton) {
   toggleSortBarExpansion()
  }
  
  private func toggleSortBarExpansion() {
    sortButton.isEnabled = false
    for index in 0...sortOptions.count - 1 {
      if sortButtonExpanded {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
          self.sortOptions[index].transform = CGAffineTransform.identity
          self.sortOptions[index].alpha = 0.0
          //self.alphabeticalSortButton.isHidden = true
        }) { completion in
          self.alphabeticalSortButton.isHidden = true
          self.sortButton.isEnabled = true
        }
      } else {
        sortOptions[index].center.x = sortButton.center.x
        sortOptions[index].center.y = sortButton.center.y
        UIView.animate(withDuration: 0.60, delay: 0.0, usingSpringWithDamping: 0.60, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
          let x = (self.sortButton?.frame.size.width ?? 0) * CGFloat(index + 1)
          self.sortOptions[index].transform = CGAffineTransform(translationX: -x, y: 0.0)
          self.sortOptions[index].alpha = 1.0
          self.sortOptions[index].isHidden = false
        }) { completion in
          self.sortButton.isEnabled = true
        }
      }
    }
    
    sortButtonExpanded = !sortButtonExpanded
  }

  @IBOutlet weak var sortButton: UIButton! {
    didSet {
      let width = sortButton.frame.width
      sortButton.layer.cornerRadius = width / 2
      sortButton.clipsToBounds = true
    }
  }
  

  @IBOutlet weak var alphabeticalSortButton: UIButton!
  
  @IBAction func alphaSortButtonPressed(_ sender: UIButton) {
    sortByAlphabetical()
  }
  
  private func sortByAlphabetical() {
    if alphaSorted == false {
      beachForecastController.beachForecasts.sort {
        $0.beach.name < $1.beach.name
      }
    } else {
      beachForecastController.beachForecasts.sort {
        $0.beach.name > $1.beach.name
      }
    }
    alphaSorted = !alphaSorted
    dataSource = BeachForecastsDataSource(beachForecastController)
  }
  
  @IBOutlet weak var tempSortButton: UIButton!
  
  @IBAction func tempSortButtonPressed(_ sender: UIButton) {
    sortByTemperature()
  }
  
  private func sortByTemperature() {
    if tempSorted {
      beachForecastController.beachForecasts.sort {
        $0.forecast!.currently.temperature < $1.forecast!.currently.temperature
      }
    } else {
      beachForecastController.beachForecasts.sort {
        $0.forecast!.currently.temperature > $1.forecast!.currently.temperature
      }
    }
    tempSorted = !tempSorted
    dataSource = BeachForecastsDataSource(beachForecastController)
  }
  
  @IBAction func regionSortButtonPressed(_ sender: UIButton) {
    sortByRegion()
  }
  
  private func sortByRegion() {
    if regionSorted {
      beachForecastController.beachForecasts.sort {
        $0.beach.side > $1.beach.side
      }
    } else {
      beachForecastController.beachForecasts.sort {
        $0.beach.side < $1.beach.side
      }
    }
    regionSorted = !regionSorted
    dataSource = BeachForecastsDataSource(beachForecastController)
  }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    //addToDatabase()
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
