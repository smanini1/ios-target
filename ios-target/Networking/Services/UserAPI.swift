//
//  UserServiceManager.swift
//  ios-target
//
//  Created by Rootstrap on 16/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class UserAPI {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let currentUserUrl = "/user/"

  class func login(_ email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_in"
    let parameters = [
      "user": [
        "email": email,
        "password": password
      ]
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      failure(error)
    })
  }

  class func signup(_ email: String, password: String, username: String, success: @escaping (_ response: [String: Any]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let parameters = [
      "user": [
        "email": email,
        "password": password,
        "password_confirmation": password,
        "username": username
      ]
    ]
    
    APIClient.request(.post, url: usersUrl, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success(response)
    }, failure: { error in
      failure(error)
    })
  }
  
  class func loginWithFacebook(token: String, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "facebook"
    let parameters = [
      "access_token": token
    ]
    APIClient.request(.post, url: url, params: parameters, success: { response, headers in
      UserAPI.saveUserSession(fromResponse: response, headers: headers)
      success()
    }, failure: { error in
      failure(error)
    })
  }
  
  class func saveUserSession(fromResponse response: [String: Any], headers: [AnyHashable: Any]) {
    UserDataManager.currentUser = try? JSONDecoder().decode(User.self, from: response["user"] as? [String: Any] ?? [:])
    if let headers = headers as? [String: Any] {
      SessionManager.currentSession = Session(headers: headers)
    }
  }
  
  class func logout(_ success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "sign_out"
    APIClient.request(.delete, url: url, success: {_, _ in 
      UserDataManager.deleteUser()
      SessionManager.deleteSession()
      success()
    }, failure: { error in
      failure(error)
    })
  }
}
