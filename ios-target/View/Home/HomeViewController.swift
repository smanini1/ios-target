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
    mapView.delegate = self
  }
  
  // MARK: - Actions
  
  @IBAction func tapOnAddTarget(_ sender: Any) {
    //  TODO:
    //    targetForm.showTargetForm()
  }
  
  @IBAction func tapOnLogoutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
  
  func removeLocationOverlay() {
    if let locationOverlay = viewModel.locationOverlay {
      mapView.removeOverlay(locationOverlay)
      viewModel.locationOverlay = nil
    }
  }
  
  func changeLocation(region: MKCoordinateRegion) {
    removeLocationOverlay()
    mapView.setRegion(region, animated: false)
    viewModel.locationOverlay = TargetCircle(radius: viewModel.locationPinRadius,
                                             backgroundColor: .white70,
                                             borderColor: .macaroniAndCheese,
                                             coordinates: region.center)
    if let overlay = viewModel.locationOverlay {
      mapView.addOverlay(overlay)
    }
  }
}

extension HomeViewController: HomeViewModelDelegate {
  func addAnnotations(annotations: [TargetAnnotation], circleOverlays: [TargetCircle]) {
    mapView.addAnnotations(annotations)
    mapView.addOverlays(circleOverlays)
  }
  
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

extension HomeViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TargetAnnotationView.reuseIdentifier) ??
      TargetAnnotationView(annotation: annotation, reuseIdentifier: TargetAnnotationView.reuseIdentifier)
    
    annotationView.canShowCallout = true
    
    if annotation === mapView.userLocation,
      let pinImage = UIImage(named: "location-pin") {
      annotationView.image = pinImage
      annotationView.centerOffset =  CGPoint(x: 0, y: -pinImage.size.height / 2)
    }
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let targetCircle = overlay as? TargetCircle {
      let circleView = MKCircleRenderer(overlay: targetCircle)
      circleView.strokeColor = targetCircle.borderColor
      circleView.fillColor = targetCircle.backgroundColor
      circleView.lineWidth = 1
      return circleView
    }
    
    return MKOverlayRenderer()
  }
}

