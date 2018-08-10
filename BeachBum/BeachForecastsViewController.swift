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
  
  @IBOutlet weak var beachForecastsCollectionView: UICollectionView! {
    didSet {
      beachForecastsCollectionView.backgroundColor = UIColor.sand
      beachForecastsCollectionView.delegate = self
      dataSource = BeachForecastsDataSource(beachForecasts: beachForecastController.beaches)
      beachForecastsCollectionView.dataSource = dataSource
    }
  }
}

//MARK: CollectionView Delegate
extension BeachForecastsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
    cell.layer.cornerRadius = 8.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sizeWidth = (collectionView.frame.size.width / 3)
    
    return CGSize(width: sizeWidth, height: sizeWidth * 1.25)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}


//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.sand
  }
}

