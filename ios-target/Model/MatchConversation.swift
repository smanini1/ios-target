//
//  MatchConversation.swift
//  ios-target
//
//  Created by Sol Manini on 7/5/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

struct MatchConversation: Codable {
  let id: Int?
  let topicId: Int?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case topicId = "topic_id"
  }
  
  init(id: Int? = nil, topicId: Int? = nil) {
    self.id = id
    self.topicId = topicId
  }
}
