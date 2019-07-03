//
//  TopicAPI.swift
//  ios-target
//
//  Created by sol manini on 7/1/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import MapKit

class TopicAPI {
  
  fileprivate static let topicsUrl = "/topics/"
  
  class func getTopics(_ success: @escaping ([Topic]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.request(.get, url: topicsUrl, success: { response, _ in
      guard let topics = response["topics"] as? [[String: Any]], !topics.isEmpty else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid topics".localized))
        return
      }
      success(Topic.parse(topics: topics))
    }, failure: failure)
  }
}
