//
//  LocationManager.swift
//  ios-target
//
//  Created by sol manini on 6/18/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol LocationDelegate: class {
  func locationChanged(location: CLLocation)
  func authorizationChanged(status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
  
  let locationManager = CLLocationManager()
  weak var locationDelegate: LocationDelegate?
  
  func setUpLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func checkLocationAuthorization() -> CLAuthorizationStatus {
    return CLLocationManager.authorizationStatus()
  }
  
  func requestWhenInUseAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func startListening() {
    locationManager.startUpdatingLocation()
  }
  
  func stopListening() {
    locationManager.stopUpdatingLocation()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    locationDelegate?.locationChanged(location: location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationDelegate?.authorizationChanged(status: status)
  }
}
