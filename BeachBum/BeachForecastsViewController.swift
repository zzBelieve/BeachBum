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
      dataSource = BeachForecastsDataSource(beachForecasts: beachForecastController.beaches)
      beachForecastsTableView.dataSource = dataSource
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
}
