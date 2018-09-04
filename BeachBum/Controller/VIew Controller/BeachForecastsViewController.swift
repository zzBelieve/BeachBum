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
      //beachForecastTableView.estimatedRowHeight = 100.0
      beachForecastTableView.register(UINib(nibName: "BeachForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "Beach Cell")
    }
  }
}



//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    //addToDatabase()
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
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 100
//  }
  
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Beach" {
      //TODO segue from table view cell
    }
  }
}

















//
////MARK: CollectionView Delegate and Flow Layout
//extension BeachForecastsViewController: UICollectionViewDelegate {
//
//  private var flowLayout: UICollectionViewFlowLayout? {
//    return beachForecastsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//  }
//
//  private func configureFlowLayout() {
//    flowLayout?.minimumInteritemSpacing = 0
//    let width = beachForecastsCollectionView.bounds.size.width * 0.5
//    flowLayout?.itemSize = CGSize(width: width, height: width * 0.6)
//    flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//  }
//
//  private func changeFlowLayout() {
//    UIView.animate(withDuration: 5.0, animations: { [weak self] in
//      self?.flowLayout?.itemSize = CGSize(width: (self?.view.bounds.size.width)!, height: (self?.view.bounds.size.height)!)
//      self?.flowLayout?.scrollDirection = .horizontal
//      self?.beachForecastsCollectionView?.isPagingEnabled = true
//      self?.flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    })
//  }

//
//  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    //cell.backgroundColor = .black
//  }
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    //changeFlowLayout() for later implementation
//  }

