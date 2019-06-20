//
//  SignUpViewModel.swift
//  ios-target
//
//  Created by German on 8/21/18.
//  Copyright © 2018 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

enum SignUpViewModelState {
  case loading
  case idle
  case error(String)
  case signedUp
}

protocol SignUpViewModelDelegate: class {
  func formDidChange()
  func didUpdateState()
}

class SignUpViewModelWithEmail {
  
  var state: SignUpViewModelState = .idle {
    didSet {
      delegate?.didUpdateState()
    }
  }
  
  weak var delegate: SignUpViewModelDelegate?
  
  var email = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var password = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var passwordConfirmation = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var username = "" {
    didSet {
      delegate?.formDidChange()
    }
  }
  
  var hasValidData: Bool {
    return email.isEmailFormatted() && !password.isEmpty && password == passwordConfirmation && !username.isEmpty
  }
  
  func signup() {
    state = .loading
    UserAPI.signup(email, password: password, username: username,
                   success: { [weak self] _ in
                    self?.state = .signedUp
                   },
                   failure: { [weak self] error in
                    let failReason = (error as NSError).localizedFailureReason ?? ""
                    let errorMessage = failReason.isEmpty ? error.localizedDescription : failReason
                    self?.state = .error(errorMessage)
                  })
  }
}
