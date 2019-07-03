//
//  TopicsViewModel.swift
//  ios-target
//
//  Created by sol manini on 7/2/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

enum TopicsViewModelState: Equatable {
  case loading
  case error(String)
  case idle
}

protocol TopicViewModelDelegate: class {
  func didUpdateState()
  func topicSelected(topic: Topic)
}

class TopicsViewModel {
  var topics: [Topic] = []
  var cellHeight = 50
  
  var topicsCount: Int {
    return topics.count
  }
  
  var collectionHeight: Int {
    return topicsCount * cellHeight + cellHeight
  }
  
  weak var delegate: TopicViewModelDelegate?
  
  var state: TopicsViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
}
