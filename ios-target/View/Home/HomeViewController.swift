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
  //  TODO:
  //  let targetForm = TargetForm()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModel.loadTargetPoints()
  }
  
  // MARK: - Actions

  @IBAction func tapOnAddTarget(_ sender: Any) {
    //  TODO:
    //    targetForm.showTargetForm()
  }
  
  @IBAction func tapOnLogoutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
  
  func changeLocation(region: MKCoordinateRegion) {
    mapView.setRegion(region, animated: true)
  }
}

extension HomeViewController: HomeViewModelDelegate {
  func showMap() {
    mapView.showsUserLocation = true
  }
  
  func showLocationError(message: String) {
    showMessage(title: "Oops", message: message)
  }
  
  func showUserLocation(region: MKCoordinateRegion) {
    changeLocation(region: region)
  }
  
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
