//
//  SignUpViewController.swift
//  ios-target
//
//  Created by Rootstrap on 5/22/17.
//  Copyright © 2017 Rootstrap. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var passwordConfirmationField: UITextField!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var backgroundImage: UIImageView!
  
  var viewModel = SignUpViewModelWithEmail()
  
  // MARK: - Lifecycle Events
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    signUpButton.enable(false)
    setUpBackground()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  func setUpBackground() {
    backgroundImage.image = UIImage(named: "background-main")
    backgroundImage.contentMode = .scaleAspectFill
    view.bringSubviewToFront(titleLabel)
  }
  
  // MARK: - Actions
  
  @IBAction func formEditingChange(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case emailField:
      viewModel.email = newValue
    case passwordField:
      viewModel.password = newValue
    case passwordConfirmationField:
      viewModel.passwordConfirmation = newValue
    case usernameField:
      viewModel.username = newValue
    default: break
    }
  }
  
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    viewModel.signup()
  }
  
  func setSignedUpRoot() {
    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    UIApplication.shared.keyWindow?.rootViewController = homeVC
  }
}

extension SignUpViewController: SignUpViewModelDelegate {
  func formDidChange() {
    signUpButton.enable(viewModel.hasValidData)
  }
  
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .signedUp:
      UIApplication.hideNetworkActivity()
      setSignedUpRoot()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Error", message: errorDescription)
    case .idle:
      UIApplication.hideNetworkActivity()
    }
  }
}
