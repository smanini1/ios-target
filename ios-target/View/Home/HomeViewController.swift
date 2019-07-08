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
  let matchNotificationSegue = "matchNotificationSegue"
  let targetFormSegue = "targetFormSegue"

  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    viewModel.loadTargetPoints()
    mapView.delegate = self
  }

  // MARK: - Actions
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == matchNotificationSegue,
      let viewController = segue.destination as? MatchNotificationViewController {
      viewController.viewModel.user = viewModel.userMatch
      viewController.delegate = self
    } else if segue.identifier == targetFormSegue,
      let viewController = segue.destination as? TargetFormViewController {
      viewController.delegate = self
      viewController.viewModel.topics = viewModel.topics
      viewController.viewModel.targetLocation.longitude = viewModel.locationCoordinates.longitude
      viewController.viewModel.targetLocation.latitude = viewModel.locationCoordinates.latitude
    }
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
    UIApplication.toggleNetworkActivity(viewModel.state == .loading)
    if case .error(let errorDescription) = viewModel.state {
      showMessage(title: "Error", message: errorDescription)
    } else if viewModel.state == .loggedOut {
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

extension HomeViewController: TargetActionsDelegate {
  func newTargetCreated(match: Match) {
    viewModel.addAnnotations(targets: [match.target])
  }
  
  func newMatchFound(match: Match) {
    viewModel.userMatch = match.user
    performSegue(withIdentifier: matchNotificationSegue, sender: nil)
  }
}

extension HomeViewController: MatchNotificationViewModelDelegate {
  func matchAccepted() {
    //TODO
  }
}
