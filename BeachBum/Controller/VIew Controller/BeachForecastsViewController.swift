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
      beachForecastsCollectionView?.dataSource = dataSource
    }
  }
  
  @IBOutlet weak var beachForecastsCollectionView: UICollectionView! {
    didSet {
      beachForecastsCollectionView.delegate = self
      configureFlowLayout()
    }
  }
}

//MARK: CollectionView Delegate and Flow Layout
extension BeachForecastsViewController: UICollectionViewDelegate {
  
  private var flowLayout: UICollectionViewFlowLayout? {
    return beachForecastsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
  }
  
  private func configureFlowLayout() {
    flowLayout?.minimumInteritemSpacing = 0
    let width = beachForecastsCollectionView.bounds.size.width * 0.5
    flowLayout?.itemSize = CGSize(width: width, height: width * 0.6)
    flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  private func changeFlowLayout() {
    UIView.animate(withDuration: 5.0, animations: { [weak self] in
      self?.flowLayout?.itemSize = CGSize(width: (self?.view.bounds.size.width)!, height: (self?.view.bounds.size.height)!)
      self?.flowLayout?.scrollDirection = .horizontal
      self?.beachForecastsCollectionView?.isPagingEnabled = true
      self?.flowLayout?.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    })
  }
  
//
//  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    //cell.backgroundColor = .black
//  }
  //  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  //
  //    //changeFlowLayout() for later implementation
  //  }
}


//MARK: View Lifecycle
extension BeachForecastsViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    //addToDatabase()
    print("fetching beaches database from firebase")
    retrieveData { [weak self] in
      self?.beachForecastController.udpateForecasts {
        DispatchQueue.main.async { [weak self] in
          print("update complete")
          self?.dataSource = BeachForecastsDataSource(self!.beachForecastController)
        }
        
      }
    }
  }
}

//MARK: Navigation
extension BeachForecastsViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "Show Beach" {
      if let detailedVC = segue.destination as? DetailedForecastViewController, let indexPath = beachForecastsCollectionView.indexPathsForSelectedItems?.first  {
        print("passing \(beachForecastController.beaches[indexPath.item].name) ")
        detailedVC.beachForecast = beachForecastController.beaches[indexPath.item]
      }
    }
  }
}

extension BeachForecastsViewController {
  func addToDatabase() {
    //TODO: add all beaches to firebase
    Database.database().reference().setValue("Data")
    let beachNames: [DatabaseBeach] = [DatabaseBeach(name: .keiki, latitude: 21.6550, longitude: -158.0600),
                                       DatabaseBeach(name: .lanikai, latitude: 21.3931, longitude: -157.7154),
                                       DatabaseBeach(name: .haleiwa, latitude: 21.5928, longitude: -158.1034)]
    let beachesDB = Database.database().reference().child("Beaches")
    
    for beach in beachNames {
      let beachesDictionary = ["Name": beach.name.rawValue,
                               "Latitude": beach.latitude,
                               "Longitude": beach.longitude] as [String : Any]
      beachesDB.childByAutoId().setValue(beachesDictionary) { (error, reference) in
        guard error == nil else { return }
        print("\(beach.name) saved")
      }
      
      
    }
  }
  
  private func retrieveData(completion: @escaping () -> Void) {
    let beachesDB = Database.database().reference().child("Beaches")
    //OBSERVE IS OFF OF THE MAIN THREAD
    beachesDB.observeSingleEvent(of: .value) { (snapshot) in
      guard let snapshot = snapshot.value as? Dictionary<String, Any> else { print("unable to retrive snapshot") ; return }
      
      for value in snapshot {
        guard let keyValue = value.value as? Dictionary<String, Any> else  { return }
        guard let name = keyValue["Name"] as? String else {print("can't find name"); return }
        guard let lat = keyValue["Latitude"] as? Double, let long = keyValue["Longitude"] as? Double else { return }
        let beach = Beach(name: name, latitude: lat, longitude: long)
        self.beachForecastController.beachNames.append(beach)
      }
      completion()
    }
  }
  
}




struct DatabaseBeach {
  
  var name: BeachName
  var latitude: Double
  var longitude: Double
}
