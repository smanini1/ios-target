//
//  HomeViewController.swift
//  ios-target
//
//  Created by Rootstrap on 5/23/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var mapView: MKMapView!
  
  var viewModel = HomeViewModel()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setLocationServices()
    viewModel.locationManager.checkLocationServices()
    setLocationServices()
    //TODO:
//    viewModel.loadTargetPoints()
  }
  
  // MARK: - Actions

  @IBAction func tapOnAddTarget(_ sender: Any) {
    //targetFrom.showTargetForm()
  }
  
  @IBAction func tapOnLogoutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
  
  func setLocationServices() {
    if CLLocationManager.locationServicesEnabled() {
      viewModel.locationManager.setUpLocationManager()
      checkLocationAuthorization()
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
      viewModel.locationManager.requestWhenInUseAuthorization()
    case .restricted:
      //TODO:
      //tell them why you cant show the location
      break
    case .authorizedAlways:
      break
    }
  }
  
  func centerViewOnUserLocation() {
    if let location = viewModel.locationManager.locationManager.location?.coordinate {
      let region = MKCoordinateRegion.init(center: location,
                                           latitudinalMeters: viewModel.regionMeters,
                                           longitudinalMeters: viewModel.regionMeters)
      mapView.setRegion(region, animated: true)
    }
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

extension HomeViewController: LocationDelegate {
  func locationChanged(locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion.init(center: center, latitudinalMeters: viewModel.regionMeters, longitudinalMeters: viewModel.regionMeters)
    mapView.setRegion(region, animated: true)
  }
  
  func authorizationChanged(status: CLAuthorizationStatus) {
    checkLocationAuthorization()
  }
}
