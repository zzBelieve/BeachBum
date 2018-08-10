//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastsViewController: UIViewController {

  var beachForecastController = BeachForecastController()
  
  private var dataSource: BeachForecastsDataSource?
  
  @IBOutlet weak var beachForecastsTableView: UITableView! {
    didSet {
      beachForecastsTableView.backgroundColor = UIColor.sand
      beachForecastsTableView.delegate = self
      dataSource = BeachForecastsDataSource(beachForecasts: beachForecastController.beaches)
      beachForecastsTableView.dataSource = dataSource
    }
  }
  
}

//MARK: Table View Delegate
extension BeachForecastsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.backgroundColor = UIColor.clear
    if let beachCell = cell as? BeachForecastTableViewCell {
      beachCell.cellView.layer.cornerRadius = 8.0
      beachCell.cellView.backgroundColor = UIColor.lightBlue
    }
    
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 100 }
}

//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.sand
  }
}
