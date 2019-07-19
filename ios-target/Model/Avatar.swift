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
    case originalUrl
    case smallThumbUrl
    case normalUrl
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(originalAvatar, forKey: .originalUrl)
    try container.encode(smallAvatar, forKey: .smallThumbUrl)
    try container.encode(normalAvatar, forKey: .normalUrl)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    originalAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .originalUrl) ?? "")
    smallAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .smallThumbUrl) ?? "")
    normalAvatar = URL(string: try container.decodeIfPresent(String.self, forKey: .normalUrl) ?? "")
  }
}
