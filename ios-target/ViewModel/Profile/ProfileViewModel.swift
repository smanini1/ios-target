//
//  ProfileViewModel.swift
//  ios-target
//
//  Created by sol manini on 7/8/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

enum ProfileViewModelState: Equatable {
  case idle
  case loading
  case error(String)
  case loggedOut
}

protocol ProfileViewModelDelegate: class {
  func didUpdateState()
  func formDidChange()
  func userDidSet()
}

class ProfileViewModel {
  
  weak var delegate: ProfileViewModelDelegate?
  
  var username = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var email = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var firstName = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var lastName = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var state: ProfileViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  func setUser(_ user: User) {
    email = user.email
    username = user.username
    firstName = user.firstName ?? ""
    lastName = user.lastName ?? ""
  }
  
  func loadUserProfile() {
    state = .loading
    UserAPI.loadUserProfile({ [weak self] user in
      self?.setUser(user)
      self?.delegate?.userDidSet()
      self?.state = .idle
      }, failure: { [weak self] error in
        self?.state = .error(error.localizedDescription)
    })
  }
  
  func hasValidData() -> Bool {
    return email.isEmailFormatted()
  }
  
  func logoutUser() {
    state = .loading
    UserAPI.logout({ [weak self] in
      self?.state = .loggedOut
      }, failure: { [weak self] error in
        self?.state = .error(error.localizedDescription)
    })
  }
}
