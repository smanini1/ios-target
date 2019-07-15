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
  @IBOutlet weak var profileImage: UIImageView!
  
  var viewModel = ProfileViewModel()
  
  var unwindProfileSegue = "unwindProfileSegue"
  
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
    profileImage.setRoundedShape(borderColor: .codGray, borderWidth: 1)
  }
  
  @IBAction func tapProfileImageButton(_ sender: Any) {
    let profileImagePicker = UIImagePickerController()
    profileImagePicker.sourceType = .photoLibrary
    profileImagePicker.delegate = self
    present(profileImagePicker, animated: true, completion: nil)
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
  
  @IBAction func tapSaveProfileButton(_ sender: Any) {
    viewModel.saveUserProfile()
  }
}

extension ProfileViewController: ProfileViewModelDelegate {
  func imageDidSet() {
    profileImage.image = viewModel.image
  }
  
  func didUpdateUserProfile() {
    performSegue(withIdentifier: unwindProfileSegue, sender: nil)
  }
  
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let image = info[.originalImage] as? UIImage {
      profileImage.image = image
      profileImage.cropsToSquare()
      viewModel.image = image
    }
    picker.dismiss(animated: true, completion:nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
