//
//  MatchConversation.swift
//  ios-target
//
//  Created by Sol Manini on 7/5/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

struct MatchListItem: Codable {
  let matchId: Int?
  let user: MatchedUser?
  let lastMessage: String?
  let topicIcon: URL?
  let unreadMessages: Int?
  
  private enum CodingKeys: String, CodingKey {
    case matchId = "match_id"
    case user 
    case lastMessage = "last_message"
    case topicIcon = "topic_icon"
    case unreadMessages = "unread_messages"
  }
  
  init(matchId: Int? = nil, user: MatchedUser? = nil, lastMessage: String? = nil, topicIcon: URL? = nil, unreadMessages: Int? = nil) {
    self.matchId = matchId
    self.user = user
    self.lastMessage = lastMessage
    self.topicIcon = topicIcon
    self.unreadMessages = unreadMessages
  }
  
  static func parse(_ matchListItems: [[String: Any]]) -> [MatchListItem] {
    var parsedMatchListItems: [MatchListItem] = []
    matchListItems.forEach { matchItem in
      if let parsedMatch = try? JSONDecoder().decode(MatchListItem.self, from: matchItem) {
        parsedMatchListItems.append(parsedMatch)
      }
    }
    return parsedMatchListItems
  }
}
