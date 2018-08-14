//
//  BeachForecastsViewController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 8/9/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import UIKit

class BeachForecastsViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  
  var beachForecastController = BeachForecastController()
  private var dataSource: BeachForecastsDataSource?
  private var flowLayout: UICollectionViewFlowLayout? {
    return beachForecastsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  private func configureFlowLayout() {
    flowLayout?.minimumInteritemSpacing = 0
    let width = beachForecastsCollectionView.frame.size.width * 0.33
    flowLayout?.itemSize = CGSize(width: width, height: width + (width * 0.20))
    flowLayout?.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
  }
  
  private func changeFlowLayout() {
    UIView.animate(withDuration: 5.0, animations: { [weak self] in
      self?.flowLayout?.itemSize = CGSize(width: (self?.view.bounds.size.width)!, height: (self?.view.bounds.size.height)!)
      self?.flowLayout?.scrollDirection = .horizontal
      self?.beachForecastsCollectionView?.isPagingEnabled = true
      self?.flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    })
  }
  
  
  @IBOutlet weak var beachForecastsCollectionView: UICollectionView! {
    didSet {
      beachForecastsCollectionView.backgroundColor = UIColor.sand
      beachForecastsCollectionView.delegate = self
      dataSource = BeachForecastsDataSource(beachForecasts: beachForecastController.beaches)
      beachForecastsCollectionView.dataSource = dataSource
      configureFlowLayout()
    }
  }
}

//MARK: CollectionView Delegate
extension BeachForecastsViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.backgroundColor = .clear
  }
  
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    //changeFlowLayout() for later implementation
//  }
  
}


//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.sand
  }
}

