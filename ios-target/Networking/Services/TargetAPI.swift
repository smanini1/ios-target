//
//  TargetAPI.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.

import UIKit

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
  
  // TODO:
//  class func createTarget(_ success: @escaping ([Target]) -> Void, failure: @escaping (_ error: Error) -> Void) {
//    APIClient.request(.get, url: targetsUrl, success: { response, _ in
//      do {
//        guard let targets = response["targets"] as? [Any], !targets.isEmpty else {
//          failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
//          return
//        }
//        success(Target.parse(targets: targets))
//      }
//    }, failure: failure)
//  }
  
}
