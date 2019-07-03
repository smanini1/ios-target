//
//  TopicsViewModel.swift
//  ios-target
//
//  Created by sol manini on 7/2/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

protocol TopicViewModelDelegate: class {
  func topicSelected(at: Int)
}

class TopicsViewModel {
  var topics: [Topic] = []
  
  var topicsCount: Int {
    return topics.count
  }

  weak var delegate: TopicViewModelDelegate?
}
