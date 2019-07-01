//
//  TargetFormViewController.swift
//  ios-target
//
//  Created by sol manini on 6/26/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class TargetFormViewController: ModalViewController {

  @IBOutlet weak var areaTextField: UITextFieldPadding!
  @IBOutlet weak var titleTextField: UITextFieldPadding!
  @IBOutlet weak var topicTextField: UITextFieldPadding!
  @IBOutlet weak var createTargetButton: UIButton!
  
  var viewModel = TargetFormViewModel()
  
  weak var delegate: TargetActionsDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    createTargetButton.enableButton(enable: false)
  }
  
  @IBAction func formEditingChange(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case areaTextField:
      viewModel.targetArea = Double(newValue) ?? 0
    case titleTextField:
      viewModel.targetTitle = newValue
    case topicTextField:
      viewModel.targetTopic = Int(newValue) ?? 0
    default: break
    }
  }
  
  @IBAction func tapSaveTargetButton(_ sender: Any) {
    viewModel.createTarget()
  }
}

extension TargetFormViewController: TargetFormViewModelDelegate, TargetActionsDelegate {
  func newTargetCreated(targets: [Target]) {
    delegate?.newTargetCreated(targets: targets)
    dismiss(animated: true)
  }
  
  func didUpdateState() {
    if viewModel.state == .loading {
      UIApplication.showNetworkActivity()
    } else {
      UIApplication.hideNetworkActivity()
    }
    
    if case .error(let description) = viewModel.state {
      showMessage(title: "Error", message: description)
    }
  }
  
  func formDidChange() {
    createTargetButton.enableButton(enable: viewModel.hasValidData)
  }
}
