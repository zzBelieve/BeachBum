//
//  StorageController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/18/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation

class StorageController {
  
  static var favoriteBeaches = MockData.mockFavoriteBeaches
  
  func addToBeaches(_ beach: Beach) {
    StorageController.favoriteBeaches.append(beach)
    print("\(beach) added to favorites")
  }
  
  func removeBeach(_ beach: Beach) {
    if let index = StorageController.favoriteBeaches.index(where: { $0.name == beach.name }) {
      print("removing beach \(StorageController.favoriteBeaches[index]) from favorites")
      StorageController.favoriteBeaches.remove(at: index)
      print(StorageController.favoriteBeaches)
    } else {
      print("nothing to remove")
    }
  }
}
