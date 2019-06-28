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
  func showUserLocation(region: MKCoordinateRegion)
  func showLocationError(message: String)
  func showMap()
  func addAnnotations(annotations: [TargetAnnotation], circleOverlays: [TargetCircle])
}

class HomeViewModel {
  
  weak var delegate: HomeViewModelDelegate?
  
  var userEmail: String?
  var targets: [Target] = []
  var locationManager: LocationManager!
  let regionMeters: Double = 1000
  let radiusDivisor: Double = 500
  let locationPinRadius: Double = 60
  var locationOverlay: TargetCircle?
  var locationLongitude: Double?
  var locationLatitude: Double?
  
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
    locationLongitude = region.center.longitude
    locationLatitude = region.center.latitude
    delegate?.showUserLocation(region: region)
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
  
  func loadTargetPoints() {
    state = .loading
    TargetAPI.getTargets({ [weak self] targets in
      self?.targets = targets
      self?.addAnnotations(targets: targets)
      self?.state = .idle
      }, failure: { [weak self] error in
        self?.state = .error(error.localizedDescription)
    })
  }
  
  func addAnnotations(targets: [Target]) {
    var annontations: [TargetAnnotation] = []
    var circleOverlays: [TargetCircle] = []
    targets.forEach { target in
      let coordinates = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
      let annotation = TargetAnnotation(coordinate: coordinates,
                                        title: target.title,
                                        subtitle: "",
                                        type: .travel,
                                        radius: target.radius)
      annontations.append(annotation)
      
      let circleOverlay = TargetCircle(radius: target.radius / radiusDivisor,
                                       backgroundColor: .macaroniAndCheese70,
                                       borderColor: .macaroniAndCheese70,
                                       coordinates: coordinates)
      circleOverlays.append(circleOverlay)
    }
    delegate?.addAnnotations(annotations: annontations, circleOverlays: circleOverlays)
  }
}

extension HomeViewModel: LocationDelegate {
  func locationChanged(location: CLLocation) {
    changeLocation(location: location)
  }
  
  func authorizationChanged(status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}
