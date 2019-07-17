//
//  MatchConversations.swift
//  ios-target
//
//  Created by sol manini on 7/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

class MatchConversationsAPI {
  
  fileprivate static let matchConversationsUrl = "/match_conversations/"
  
  class func getMatchConversations(_ success: @escaping ([MatchListItem]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.request(.get, url: matchConversationsUrl, success: { response, _ in
      guard let matchListItems = response["matches"] as? [[String: Any]] else {
        failure(App.error(domain: .parsing, localizedDescription: "Could not parse valid match conversations".localized))
        return
      }
      success(MatchListItem.parse(matchListItems))
    }, failure: failure)
  }
}
