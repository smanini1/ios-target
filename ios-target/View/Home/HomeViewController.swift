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
      setupTargetController(viewController)
    }
  }
  
  func setupTargetController(_ viewController: TargetFormViewController) {
    viewController.delegate = self
    viewController.viewModel.target = viewModel.target
    viewController.viewModel.topics = viewModel.topics
  }
  
  @IBAction func prepareForUnwindProfileSegue(segue: UIStoryboardSegue) {}
  
  @IBAction func prepareForUnwindChatSegue(segue: UIStoryboardSegue) {}
  
  @IBAction func tapOnCreateTargetButton(_ sender: Any) {
    viewModel.target = Target(id: nil,
                              title: "",
                              latitude: viewModel.locationLatitude,
                              longitude: viewModel.locationLongitude,
                              radius: 0,
                              topicId: 0)
    performSegue(withIdentifier: targetFormSegue, sender: nil)
  }
  
  @IBAction func tapOnLogoutButton(_ sender: Any) {
//    TODO
//    viewModel.logoutUser()
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
  
  func removeTargetAnnotation(targetId: Int) {
    viewModel.removeTarget(targetId: targetId)
    
    mapView.annotations.forEach {
      if
        let annotation = $0 as? TargetAnnotation,
        annotation.target.id == targetId
      {
        mapView.removeAnnotation(annotation)
        removeTargetOverlay(targetId: targetId)
      }
    }
  }
  
  func removeTargetOverlay(targetId: Int) {
    guard
      let overlays = mapView.overlays as? [TargetCircle],
      let index = overlays.index(where: { $0.targetId == targetId })
    else { return }
    mapView.removeOverlay(mapView.overlays[index])
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
    }
  }
}

extension HomeViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: TargetAnnotationView.reuseIdentifier) ??
      TargetAnnotationView(annotation: annotation, reuseIdentifier: TargetAnnotationView.reuseIdentifier)
    
    annotationView.canShowCallout = false
    
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

  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let annotation = view.annotation as? TargetAnnotation {
      viewModel.target = annotation.target
      performSegue(withIdentifier: targetFormSegue, sender: nil)
    }
  }
}

extension HomeViewController: TargetActionsDelegate {
  func targetDeleted(targetId: Int) {
    removeTargetAnnotation(targetId: targetId)
  }
  
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
