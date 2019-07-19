//
//  ConversationViewController.swift
//  ios-target
//
//  Created by Sol Manini on 7/19/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
  
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var targetNameLabel: UILabel!
  
  var viewModel = ConversationViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setupView()
    //TODO
//    viewModel.loadConversation()
  }
  
  func setupView() {
    guard let user = viewModel.match?.user else { return }
    userNameLabel.text = user.fullName
  }
}

extension ConversationViewController: ConversationViewModelDelegate {
  func didUpdateState() {
    UIApplication.toggleNetworkActivity(viewModel.state == .loading)
    if case .error(let description) = viewModel.state {
      showMessage(title: "Error", message: description)
    }
  }
}
