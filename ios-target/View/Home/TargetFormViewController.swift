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
    setCreateTargetButton(enabled: false)
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
  
  func setCreateTargetButton(enabled: Bool) {
    createTargetButton.alpha = enabled ? 1 : 0.5
    createTargetButton.isEnabled = enabled
  }
}

extension TargetFormViewController: TargetFormViewModelDelegate, TargetActionsDelegate {
  func newTargetCreated(targets: [Target]) {
    delegate?.newTargetCreated(targets: targets)
    dismiss(animated: true)
  }
  
  func didUpdateState() {
    switch viewModel.state {
    case .idle:
      UIApplication.hideNetworkActivity()
    case .loading:
      UIApplication.showNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Error", message: errorDescription)
    case .saved:
      UIApplication.hideNetworkActivity()
    }
  }
  
  func formDidChange() {
    setCreateTargetButton(enabled: viewModel.hasValidData)
  }
}
