//
//  ConversationViewModel.swift
//  ios-target
//
//  Created by Sol Manini on 7/19/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

enum ConversationViewModelState: Equatable {
  case idle
  case loading
  case error(String)
}

protocol ConversationViewModelDelegate: class {
  func didUpdateState()
}

class ConversationViewModel {
  
  weak var delegate: ConversationViewModelDelegate?
  
  var state: ConversationViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  var match: MatchListItem? 
  
  func loadConversation() {
    //TODO
//    state = .loading
//    MatchConversationsAPI.loadConversation()
  }
}
