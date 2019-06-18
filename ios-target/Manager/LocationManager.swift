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

class LocationManager: NSObject {
  
  let locationManager = CLLocationManager()
  var mapView = MKMapView()
  weak var locationDelegate: LocationDelegate?
  
  func setUpLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setUpLocationManager()
    } else {
      //TODO:
      // show alert to turn on
    }
  }
  
  func requestWhenInUseAuthorization() {
    locationManager.requestWhenInUseAuthorization()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationDelegate?.locationChanged(locations: locations)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationDelegate?.authorizationChanged(status: status)
    
  }
  
}
