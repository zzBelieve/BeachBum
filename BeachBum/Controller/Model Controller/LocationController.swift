//
//  LocationController.swift
//  BeachBum
//
//  Created by Jordan Dumlao on 9/7/18.
//  Copyright © 2018 Jordan Dumlao. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
}
