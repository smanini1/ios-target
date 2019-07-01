//
//  Target.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

struct Target: Codable {
  var id: Int?
  var title: String
  var latitude: Double
  var longitude: Double
  var radius: Double
  var topicId: Int
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case latitude = "lat"
    case longitude = "lng"
    case radius
    case topicId = "topic_id"
  }
  
  init(id: Int?, title: String, latitude: Double, longitude: Double, radius: Double, topicId: Int) {
    self.id = id
    self.title = title
    self.latitude = latitude
    self.longitude = longitude
    self.radius = radius
    self.topicId = topicId
  }
  
  static func buildParams(target: Target) -> [String: Any] {
    let parameters = [
      "target": [
        "title": target.title,
        "lat": target.latitude,
        "lng": target.longitude,
        "radius": target.radius,
        "topic_id": target.topicId
      ]
    ]
    
    return parameters
  }
  
  static func parse(targets: [[String: Any]]) -> [Target] {
    var parsedTargets: [Target] = []
    
    targets.forEach { target in
      if
        let actualTarget = target["target"] as? [String: Any],
        let parsedTarget = try? JSONDecoder().decode(Target.self, from: actualTarget)
      {
        parsedTargets.append(parsedTarget)
      }
    }
    return parsedTargets
  }
}
