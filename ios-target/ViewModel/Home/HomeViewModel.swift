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
  var topics: [Topic] = []
  var locationManager: LocationManager!
  let regionMeters: Double = 1000
  let radiusDivisor: Double = 500
  let locationPinRadius: Double = 60
  var locationOverlay: TargetCircle?
  var locationCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  
  var locationLatitude: CLLocationDegrees {
    return locationCoordinates.latitude
  }
  
  var locationLongitude: CLLocationDegrees {
    return locationCoordinates.longitude
  }
  
  var userMatch: User?
  var target: Target?
  
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
    locationCoordinates.longitude = region.center.longitude
    locationCoordinates.latitude = region.center.latitude
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
    var error: Error?
    let dispatchGroup = DispatchGroup()
    
    dispatchGroup.enter()
    TopicAPI.getTopics({ [weak self] topics in
      self?.topics = topics
      dispatchGroup.leave()
      }, failure: { topicError in
        error = topicError
        dispatchGroup.leave()
    })
    
    dispatchGroup.enter()
    TargetAPI.getTargets({ [weak self] targets in
      self?.targets = targets
      dispatchGroup.leave()
      }, failure: { targetError in
        error = targetError
        dispatchGroup.leave()
    })
    
    dispatchGroup.notify(queue: .main) { [weak self] in
      guard let self = self else { return }
      self.addAnnotations(targets: self.targets)
      if let error = error {
        self.state = .error(error.localizedDescription)
      } else {
        self.state = .idle
      }
    }
  }
  
  func addAnnotations(targets: [Target]) {
    var annontations: [TargetAnnotation] = []
    var circleOverlays: [TargetCircle] = []
    targets.forEach { target in
      let coordinates = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
      let annotation = createAnnotation(target: target, coordinates: coordinates)
      annontations.append(annotation)
      let circleOverlay = TargetCircle(radius: target.radius / radiusDivisor,
                                       backgroundColor: .macaroniAndCheese70,
                                       borderColor: .macaroniAndCheese70,
                                       coordinates: coordinates)
      circleOverlay.targetId = target.id
      circleOverlays.append(circleOverlay)
    }
    delegate?.addAnnotations(annotations: annontations, circleOverlays: circleOverlays)
  }
  
  func createAnnotation(target: Target, coordinates: CLLocationCoordinate2D) -> TargetAnnotation {
    let topic = topics.first(where: { $0.id == target.topicId })
    let targetType = TargetType(rawValue: topic?.label.lowercased() ?? "travel") ?? .travel
    let annotation = TargetAnnotation(id: target.id ?? 0,
                                      coordinate: coordinates,
                                      type: targetType,
                                      target: target)
    return annotation
  }
  
  func removeTarget(targetId: Int) {
    guard let index = targets.index(where: {$0.id == targetId}) else { return }
    targets.remove(at: index)
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
