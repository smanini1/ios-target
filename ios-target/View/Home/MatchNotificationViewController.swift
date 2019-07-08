//
//  MatchNotificationViewController.swift
//  ios-target
//
//  Created by sol manini on 7/3/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class MatchNotificationViewController: ModalViewController {
  
  @IBOutlet weak var connectMatchButton: UIButton!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userImage: UIImageView!
  
  var viewModel = MatchNotificationViewModel()
  
  weak var delegate: MatchNotificationViewModelDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    connectMatchButton.backgroundColor = .macaroniAndCheese
    userNameLabel.text = viewModel.userEmail
    setImageOnUserImageView()
  }
  
  func setImageOnUserImageView() {
    userImage.setImage(with: viewModel.userImage, placeholder: "profile-icon")
    userImage.layer.borderWidth = 1
    userImage.layer.masksToBounds = false
    userImage.layer.borderColor = UIColor.codGray.cgColor
    userImage.layer.cornerRadius = userImage.frame.height / 2
    userImage.clipsToBounds = true
  }
  
  @IBAction func tapOnSkipButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func tapConnectMatchButton(_ sender: Any) {
    delegate?.matchAccepted()
  }
}
