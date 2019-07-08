//
//  MatchNotificationViewModel.swift
//  ios-target
//
//  Created by sol manini on 7/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

protocol MatchNotificationViewModelDelegate: class {
  func matchAccepted()
}

class MatchNotificationViewModel {
  var user: User?
  
  var userEmail: String? {
    return user?.email
  }
  
  var userImage: URL? {
    return user?.image
  }
}
