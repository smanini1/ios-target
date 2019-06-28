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
  case saved
}

protocol TargetFormViewModelDelegate: class {
  func didUpdateState()
  func formDidChange()
}

protocol TargetActionsDelegate: class {
  func newTargetCreated(targets: [Target])
}

class TargetFormViewModel {
  
  var state: TargetFormViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: (TargetFormViewModelDelegate & TargetActionsDelegate)?
  
  var targetTitle = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var targetLongitude: Double = 0 {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var targetLatitude: Double = 0 {
    didSet {
      delegate?.formDidChange()
    }
  }
  
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
      && targetLongitude != 0 && targetLatitude != 0
  }
  
  func createTarget() {
    state = .loading
    let location = CLLocationCoordinate2D(latitude: targetLatitude, longitude: targetLongitude)
    TargetAPI.createTarget(targetTitle,
                           targetArea: targetArea,
                           targetTopic: targetTopic,
                           targetLocation: location,
                           success: {[weak self] target in
                            self?.state = .saved
                            self?.delegate?.newTargetCreated(targets: [target])
      },
                           failure: { [weak self] error in
                            let failReason = (error as NSError).localizedFailureReason ?? ""
                            let errorMessage = failReason.isEmpty ? error.localizedDescription : failReason
                            self?.state = .error(errorMessage)
    })
  }
}
