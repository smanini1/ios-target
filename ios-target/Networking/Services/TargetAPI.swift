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
      guard let targets = response["targets"] as? [[String: Any]] else {
          failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
          return
        }
        success(Target.parse(targets: targets))
    }, failure: failure)
  }
  
  class func createTarget(_ target: Target, success: @escaping (_ response: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = Target.buildParams(target: target)
    APIClient.request(.post, url: targetsUrl, params: parameters, success: { response, _ in
      if let target = response["target"] as? [String: Any],
        let parsedTarget = try? JSONDecoder().decode(Target.self, from: target) {
        
        if let matchConversation = response["match_conversation"] as? [String: Any],
          let topidId = matchConversation["topic_id"],
          let matchedUser = response["matched_user"] as? [String: Any],
          let user = try? JSONDecoder().decode(User.self, from: matchedUser)
        {
          if let userAvatar = matchedUser["avatar"] as? [String: Any],
            let userSmallImage = userAvatar["small_thumb_url"] as? URL {
            user.image = userSmallImage
          }
          success(["target": parsedTarget, "topic": topidId, "user": user])
        } else {
          success(["target": parsedTarget])
        }
      } else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid targets".localized))
        return
      }
    }, failure: { error in
      failure(error)
    })
  }
}
