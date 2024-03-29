//
//  TargetAPI.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.

import UIKit
import MapKit
import Alamofire

class TargetAPI {
  
  fileprivate static let targetsUrl = "/targets/"
  
  class func getTargets(_ success: @escaping ([Target]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.request(.get, url: targetsUrl, success: { response, _ in
      guard let targets = response["targets"] as? [[String: Any]] else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
        return
      }
      success(Target.parse(targets: targets))
    }, failure: failure)
  }
  
  class func createTarget(_ target: Target, success: @escaping (_ response: Match) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = Target.buildParams(target: target)
    APIClient.request(.post, url: targetsUrl, params: parameters, success: { response, _ in
      if let match = try? JSONDecoder().decode(Match.self, from: response) {
        if
          let matchedUser = response["matched_user"] as? [String: Any],
          let userAvatar = matchedUser["avatar"] as? [String: Any],
          let decodedAvatar = try? JSONDecoder().decode(Avatar.self, from: userAvatar)
        {
          match.user?.image = decodedAvatar.smallAvatar
        }
        success(match)
      } else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
        return
      }
    }, failure: { error in
      failure(error)
    })
  }
  
  class func deleteTarget(_ targetId: Int, success: (() -> Void)? = nil, failure: ((_ error: Error) -> Void)? = nil) {
    let url = targetsUrl + String(targetId)
    APIClient.request(.delete, url: url, success: {_, _ in 
      success?()
    }, failure: { error in
      // Dirty fix for backend error
      if error is Alamofire.AFError {
        success?()
      } else {
        failure?(error)
      }
    })
  }
  
  // TODO: pending feature for missing backend
//  class func editTarget(_ target: Target, targetId: Int, success: @escaping (_ response: Match) -> Void, failure: @escaping (_ error: Error) -> Void) {
//    let parameters = Target.buildParams(target: target)
//    let url = targetsUrl + String(targetId)
//    APIClient.request(.put, url: url, params: parameters, success: { response, _ in
//      if let match = try? JSONDecoder().decode(Match.self, from: response) {
//        if let matchedUser = response["matched_user"] as? [String: Any],
//          let userAvatar = matchedUser["avatar"] as? [String: Any],
//          let userSmallImage = userAvatar["small_thumb_url"] as? URL {
//          match.user?.image = userSmallImage
//        }
//        success(match)
//      } else {
//        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
//        return
//      }
//    }, failure: { error in
//      failure(error)
//    })
//  }
}
