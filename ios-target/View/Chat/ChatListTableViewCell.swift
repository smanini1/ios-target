//
//  ChatListTableViewCell.swift
//  ios-target
//
//  Created by sol manini on 7/16/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var userPictureImageView: UIImageView!
  @IBOutlet weak var targetIconImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  @IBOutlet weak var notificationsLabel: UILabel!
  
  static let reuseIdentifier = "ChatListTableViewCell"
  
  var match: MatchListItem? {
    didSet {
      updateCell(match)
    }
  }
  
  func updateCell(_ match: MatchListItem?) {
    if let notificationCount = match?.unreadMessages,
      notificationCount > 0 {
      setMessageNotification(notificationCount)
    } else {
      notificationsLabel.isHidden = true
    }
    
    if let user = match?.user {
      setMatchedUser(user)
    }
    
    lastMessageLabel.text = match?.lastMessage == nil ? "No messages found".localized : match?.lastMessage
    targetIconImageView.setImage(with: match?.topicIcon, placeholder: "travel-pin")
  }
  
  func setMatchedUser(_ user: MatchedUser) {
    userNameLabel.text = user.fullName == "" ? "unknown".localized : user.fullName
    userPictureImageView.setImage(with: user.avatar?.smallAvatar, placeholder: "profile-icon")
    userPictureImageView.setRoundedShape(borderColor: .codGray, borderWidth: 1)
  }
  
  func setMessageNotification(_ notificationCount: Int) {
    notificationsLabel.setRoundBorders()
    notificationsLabel.text = String(notificationCount)
    notificationsLabel.backgroundColor = .macaroniAndCheese
    notificationsLabel.isHidden = false
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

