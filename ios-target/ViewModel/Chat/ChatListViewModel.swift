//
//  ChatListViewModel.swift
//  ios-target
//
//  Created by sol manini on 7/16/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

enum ChatListViewModelState: Equatable {
  case idle
  case loading
  case error(String)
}

protocol ChatListViewModelDelegate: class {
  func didUpdateState()
  func didLoadMatches()
}

class ChatListViewModel {
  
  weak var delegate: ChatListViewModelDelegate?
  
  var matches: [MatchListItem] = [] {
    didSet {
      delegate?.didLoadMatches()
    }
  }
  
  var matchCount: Int {
    return matches.count
  }
  
  var state: ChatListViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  func loadConversations() {
    state = .loading
    MatchConversationsAPI.getMatchConversations({ [weak self] matches in
      self?.state = .idle
      self?.matches = matches
      }, failure: { [weak self] matchError in
        self?.state = .error(matchError.localizedDescription)
    })
  }
}

