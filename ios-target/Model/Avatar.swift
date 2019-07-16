//
//  Avatar.swift
//  ios-target
//
//  Created by Sol Manini on 7/15/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation

class Avatar: Codable {
  var originalAvatar: URL?
  var smallAvatar: URL?
  var normalAvatar: URL?
  
  private enum CodingKeys: String, CodingKey {
    case originalAvatar = "original_url"
    case smallAvatar = "small_thumb_url"
    case normalAvatar = "normal_url"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(originalAvatar, forKey: .originalAvatar)
    try container.encode(smallAvatar, forKey: .smallAvatar)
    try container.encode(normalAvatar, forKey: .normalAvatar)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    originalAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .originalAvatar) ?? "")
    smallAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .smallAvatar) ?? "")
    normalAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .normalAvatar) ?? "")
  }
}
