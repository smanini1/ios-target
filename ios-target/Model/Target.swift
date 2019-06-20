//
//  Target.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

class Target: Codable {
  var id: Int
  var title: String
  var lat: Double
  var lng: Double
  var radius: Double
  var topicId: Int
  
  private enum CodingKeys: String, CodingKey {
    case id
    case title
    case lat
    case lng
    case radius
    case topicId = "topic_id"
  }
  
  init(id: Int, title: String = "", lat: Double, lng: Double = 0,
       radius: Double = 0, topicId: Int = 0) {
    self.id = id
    self.title = title
    self.lat = lat
    self.lng = lng
    self.radius = radius
    self.topicId = topicId
  }
  
  //MARK: Codable
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(lat, forKey: .lat)
    try container.encode(lng, forKey: .lng)
    try container.encode(radius, forKey: .radius)
    try container.encode(topicId, forKey: .topicId)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      id = try container.decode(Int.self, forKey: .id)
    } catch {
      id = Int(try container.decode(Int.self, forKey: .id))
    }
    title = try container.decode(String.self, forKey: .title)
    lat = try container.decode(Double.self, forKey: .lat)
    lng = try container.decode(Double.self, forKey: .lng)
    radius = try container.decode(Double.self, forKey: .radius)
    topicId = try container.decode(Int.self, forKey: .topicId)
  }
  
  static func parse(targets: [Any]) -> [Target] {
    var parsedTargets: [Target] = []
    for target in targets {
      if let target = target as? [String: Any], let actualTarget = target["target"], let parsedTarget = try? JSONDecoder().decode(Target.self, from: actualTarget as? [String: Any] ?? [:]) {
          parsedTargets.append(parsedTarget)
      }
    }
    return parsedTargets
  }
}
