//
//  HomeViewController.swift
//  ios-target
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  let regionMeters: Double = 1000
  
  var viewModel = HomeViewModel()
  
  // MARK: - Lifecycle Events
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    checkLocationServices()
    //TODO:
    //viewModel.loadTargetPoints()
  }
  
  func setUpLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func centerViewOnUserLocation() {
    if let location = locationManager.location?.coordinate {
      let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func checkLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      setUpLocationManager()
      checkLocationAuthorization()
    } else {
      //TODO:
      // show alert to turn on
    }
  }
  
  func checkLocationAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .authorizedWhenInUse:
      mapView.showsUserLocation = true
      centerViewOnUserLocation()
    case .denied:
      //TODO:
      //Show alert instricting them how to turn on permissions
      break
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      //TODO:
      //tell them why you cant show the location
      break
    case .authorizedAlways:
      break
    }
  }
  
  // MARK: - Actions

  @IBAction func tapOnLogoutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
}

extension HomeViewController: HomeViewModelDelegate {
  func didUpdateState() {
    switch viewModel.state {
    case .idle:
      UIApplication.hideNetworkActivity()
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      print(errorDescription)
    case .loggedOut:
      UIApplication.hideNetworkActivity()
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
    }
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionMeters, longitudinalMeters: regionMeters)
    mapView.setRegion(region, animated: true)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
  
}
