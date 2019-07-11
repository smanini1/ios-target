//
//  ProfileViewController.swift
//  ios-target
//
//  Created by sol manini on 7/8/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var usernameTextField: UITextFieldPadding!
  @IBOutlet weak var emailTextField: UITextFieldPadding!
  @IBOutlet weak var firstNameTextField: UITextFieldPadding!
  @IBOutlet weak var lastNameTextField: UITextFieldPadding!
  @IBOutlet weak var saveProfileButton: UIButton!
  
  var viewModel = ProfileViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    saveProfileButton.enable(false)
    viewModel.loadUserProfile()
  }
  
  func configureView() {
    usernameTextField.text = viewModel.username
    emailTextField.text = viewModel.email
    firstNameTextField.text = viewModel.firstName
    lastNameTextField.text = viewModel.lastName
  }
  
  @IBAction func formEditingChanged(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case usernameTextField:
      viewModel.username = newValue
    case emailTextField:
      viewModel.email = newValue
    case firstNameTextField:
      viewModel.firstName = newValue
    case lastNameTextField:
      viewModel.lastName = newValue
    default:
      break
    }
  }
  
  @IBAction func tapLogoutButton(_ sender: Any) {
    viewModel.logoutUser()
  }
}

extension ProfileViewController: ProfileViewModelDelegate {
  func userDidSet() {
    configureView()
  }
  
  func didUpdateState() {
    UIApplication.toggleNetworkActivity(viewModel.state == .loading)
    if case .error(let errorDescription) = viewModel.state {
      showMessage(title: "Error", message: errorDescription)
    } else if viewModel.state == .loggedOut {
      UIApplication.shared.keyWindow?.rootViewController = self.storyboard?.instantiateInitialViewController()
    }
  }
  
  func formDidChange() {
    saveProfileButton.enable(viewModel.hasValidData())
  }
}
