//
//  Target.swift
//  ios-target
//
//  Created by sol manini on 6/12/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

struct Topic: Codable {
  var id: Int?
  var label: String
  var image: UIImage?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case label
  }
  
  init(id: Int?, label: String) {
    self.id = id
    self.label = label
  }
  
  static func parse(topics: [[String: Any]]) -> [Topic] {
    var parsedTopics: [Topic] = []
    
    topics.forEach { topic in
      if
        let actualTopic = topic["topic"] as? [String: Any],
        var parsedTopic = try? JSONDecoder().decode(Topic.self, from: actualTopic)
      {
        let imageName = parsedTopic.label.lowercased() + "-pin"
        parsedTopic.image = UIImage(named: imageName) ?? UIImage(named: "travel-pin")
        parsedTopics.append(parsedTopic)
      }
    }
    return parsedTopics
  }
}
