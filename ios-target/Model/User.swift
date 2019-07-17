//
//  User.swift
//  ios-target
//
//  Created by Rootstrap on 1/18/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import Foundation

struct MatchedUser: Codable {
  var id: Int?
  var avatar: Avatar?
  var fullName: String?
  
  private enum CodingKeys: String, CodingKey {
    case id
    case fullName = "full_name"
    case avatar = "avatar"
  }
}

class User: Codable {
  var id: String?
  var username: String?
  var email: String?
  var image: URL?
  var firstName: String?
  var lastName: String?

  private enum CodingKeys: String, CodingKey {
    case id
    case username
    case email
    case image = "profile_picture"
    case firstName = "first_name"
    case lastName = "last_name"
  }
  
  init(id: String? = nil, username: String? = nil, email: String? = nil) {
    self.id = id
    self.username = username
    self.email = email
  }
  
  //MARK: Codable

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(username, forKey: .username)
    try container.encode(email, forKey: .email)
    try container.encode(image?.absoluteString, forKey: .image)
    try container.encode(firstName, forKey: .firstName)
    try container.encode(lastName, forKey: .lastName)
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    do {
      id = try container.decode(String.self, forKey: .id)
    } catch {
      id = String(try container.decode(Int.self, forKey: .id))
    }
    username = try container.decode(String.self, forKey: .username)
    email = try container.decode(String.self, forKey: .email)
    image = URL(string: try container.decodeIfPresent(String.self, forKey: .image) ?? "")
    firstName = try container.decode(String.self, forKey: .firstName)
    lastName = try container.decode(String.self, forKey: .lastName)
  }
  
  func buildParams(_ image: String) -> [String: Any] {
    let parameters = [
      "user": [
        "username": username,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "gender": "",
        "avatar": image
      ]
    ]
    
    return parameters
  }
}
