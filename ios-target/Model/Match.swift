//
//  Match.swift
//  ios-target
//
//  Created by Sol Manini on 7/5/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

struct Match: Codable {
    let user: User?
    let target: Target
    let conversation: MatchConversation?
    
    private enum CodingKeys: String, CodingKey {
        case user = "matched_user"
        case target
        case conversation = "match_conversation"
    }
    
    init(user: User?, target: Target, conversarion: MatchConversation?) {
        self.user = user
        self.target = target
        self.conversation = conversarion
    }
}
