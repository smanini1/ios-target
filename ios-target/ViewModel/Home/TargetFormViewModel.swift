//
//  TargetFormViewModel.swift
//  ios-target
//
//  Created by sol manini on 6/27/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum TargetFormViewModelState: Equatable {
  case loading
  case error(String)
  case idle
}

protocol TargetFormViewModelDelegate: class {
  func didUpdateState()
  func formDidChange()
}

protocol TargetActionsDelegate: class {
  func newTargetCreated(match: Match)
  func newMatchFound(match: Match)
}

class TargetFormViewModel {
  
  var topics: [Topic] = []
  
  var state: TargetFormViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: (TargetFormViewModelDelegate & TargetActionsDelegate & TopicViewModelDelegate)?
  
  var target: Target?
  
  var isEditingTarget: Bool {
    return target?.id != 0
  }
  
  var targetTitle = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var targetLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  
  var targetArea: Double = 0 {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var targetTopic = 0 {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var username = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var hasValidData: Bool {
    return !targetTitle.isEmpty && targetArea != 0 && targetTopic != 0
      && targetLocation.latitude != 0 && targetLocation.longitude != 0
  }
  
  func setTarget() {
    guard let target = target else { return }
    targetTitle = target.title
    targetTopic = target.topicId
    targetArea = target.radius
    targetLocation = CLLocationCoordinate2D(latitude: target.latitude, longitude: target.longitude)
  }
  
  func createTarget() {
    state = .loading
    let target = Target(id: nil,
                        title: targetTitle,
                        latitude: targetLocation.latitude,
                        longitude: targetLocation.longitude,
                        radius: targetArea,
                        topicId: targetTopic)
    TargetAPI.createTarget(target,
                           success: { [weak self] match in
                            self?.state = .idle
                            self?.delegate?.newTargetCreated(match: match)
      },
                           failure: { [weak self] error in
                            let failReason = (error as NSError).localizedFailureReason ?? ""
                            let errorMessage = failReason.isEmpty ? error.localizedDescription : failReason
                            self?.state = .error(errorMessage)
    })
  }
}
