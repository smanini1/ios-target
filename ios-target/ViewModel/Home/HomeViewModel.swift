//
//  HomeViewModel.swift
//  ios-target
//
//  Created by German on 8/3/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum HomeViewModelState: Equatable {
  case loading
  case error(String)
  case idle
  case loggedOut
}

protocol HomeViewModelDelegate: class {
  func didUpdateState()
  func didUpdateLocation(region: MKCoordinateRegion)
  func showUserLocation(region: MKCoordinateRegion)
  func showLocationError(message: String)
  func showMap()
}

class HomeViewModel {
  
  weak var delegate: HomeViewModelDelegate?
  
  var userEmail: String?
  var targets: [Target] = []
  var locationManager: LocationManager!
  let regionMeters: Double = 1000
  
  var state: HomeViewModelState = .idle {
    didSet {
        delegate?.didUpdateState()
    }
  }
  
  init(locationManager: LocationManager = LocationManager()) {
    self.locationManager = locationManager
    self.locationManager.locationDelegate = self
    self.setLocationServices()
  }
  
  func setLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.setUpLocationManager()
      checkLocationAuthorization()
    }
  }
  
  func logoutUser() {
    state = .loading
    UserAPI.logout({ [weak self] in
      self?.state = .loggedOut
    }, failure: { [weak self] error in
      self?.state = .error(error.localizedDescription)
    })
  }
  
  func defineRegion(location: CLLocation) -> MKCoordinateRegion {
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    return MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
  }
  
  func changeLocation(location: CLLocation) {
    let region = defineRegion(location: location)
    delegate?.didUpdateLocation(region: region)
  }
  
  func checkLocationAuthorization() {
    locationManager.stopListening()
    switch locationManager.checkLocationAuthorization() {
    case .authorizedWhenInUse:
      delegate?.showMap()
      guard let location = locationManager.locationManager.location else { return }
      let region = defineRegion(location: location)
      locationManager.startListening()
      delegate?.showUserLocation(region: region)
    case .denied:
      delegate?.showLocationError(message: "Please change location permissions")
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      delegate?.showLocationError(message: "Sorry! We can't show your location")
    case .authorizedAlways:
      break
    }
  }
  
//TODO:
//  func loadTargetPoints() {
//    state = .loading
//    TargetAPI.getTargets({ [weak self] targets in
//      self?.targets = targets
//      self?.state = .idle
//      }, failure: { [weak self] error in
//        self?.state = .error(error.localizedDescription)
//    })
//  }
}

extension HomeViewModel: LocationDelegate {
  func locationChanged(location: CLLocation) {
    changeLocation(location: location)
  }
  
  func authorizationChanged(status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}
