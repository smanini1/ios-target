//
//  TargetAPI.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.

import UIKit
import MapKit

class TargetAPI {
  
  fileprivate static let targetsUrl = "/targets/"
  
  class func getTargets(_ success: @escaping ([Target]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.request(.get, url: targetsUrl, success: { response, _ in
      guard let targets = response["targets"] as? [[String: Any]], !targets.isEmpty else {
          failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
          return
        }
        success(Target.parse(targets: targets))
    }, failure: failure)
  }
  
  class func createTarget(_ targetTitle: String, targetArea: Double, targetTopic: Int, targetLocation: CLLocationCoordinate2D, success: @escaping (_ response: Target) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = [
      "target": [
        "title": targetTitle,
        "lat": targetLocation.latitude,
        "lng": targetLocation.longitude,
        "radius": targetArea,
        "topic_id": targetTopic
      ]
    ]
    APIClient.request(.post, url: targetsUrl, params: parameters, success: { response, _ in
      guard let target = response["target"] as? [String: Any], !target.isEmpty, let parsedTarget = try? JSONDecoder().decode(Target.self, from: target) else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
        return
      }
      success(parsedTarget)
    }, failure: { error in
      failure(error)
    })
  }
}
