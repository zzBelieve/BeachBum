//
//  StorageController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/18/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import UIKit

class StorageController {
  
  static var mockFavoriteBeaches: [Beach] = MockData.mockFavoriteBeaches
  private let notificationCenter: NotificationCenter
  private var url: URL? {
    return try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("favorites.json")
  }
  
  init() {
    self.notificationCenter = NotificationCenter.default
    
  }
  
  func saveData(_ beaches: [Beach]) {
    guard let url = url else { print("invalid url"); return }
    let jsonData = beaches.compactMap { $0.json } as NSArray
    do {
      print("writing \(jsonData) to disk")
      try jsonData.write(to: url)
      print("success")
      //tell notification center of change
      notificationCenter.post(name: .StorageObserver, object: self)
    } catch {
      print(error)
    }
  }
  
  func saveData(_ beach: Beach) {
    guard let url = url else { print("invalid url"); return }
    let beaches = loadData() ?? [Beach]()
    guard !beaches.contains(where: { $0.name == beach.name } ) else { print("beach exists"); return }
    let jsonData = beaches.compactMap { $0.json } as NSArray
    do {
      print("writing \(jsonData) to disk")
      try jsonData.write(to: url)
      print("success")
      //tell notification center of change
      notificationCenter.post(name: .StorageObserver, object: self)
    } catch {
      print(error)
    }
  }
  
  func loadData() -> [Beach]?{
    guard let url = url else { print("inavlid url"); return nil}
    guard let array = NSArray(contentsOf:url) as? [Data] else { print("invalid data"); return nil }
    let beaches = array.compactMap { Beach(json: $0) }
    return beaches
  }
}

extension Notification.Name {
  static let StorageObserver = Notification.Name("StorageObserver")
}
