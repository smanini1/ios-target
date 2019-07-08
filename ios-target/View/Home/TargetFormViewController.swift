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
  @IBOutlet weak var selectTopicButton: UIButton!
  @IBOutlet weak var createTargetButton: UIButton!
  
  var viewModel = TargetFormViewModel()
  
  weak var delegate: TargetActionsDelegate?
  
  let topicsSegue = "topicsSegue"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    createTargetButton.enable(false)
    selectTopicButton.addBorder(color: .black, weight: 1)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? TopicsViewController {
      viewController.delegate = self
      viewController.viewModel.topics = viewModel.topics
    }
  }
  
  @IBAction func formEditingChange(_ sender: UITextField) {
    let newValue = sender.text ?? ""
    switch sender {
    case areaTextField:
      viewModel.targetArea = Double(newValue) ?? 0
    case titleTextField:
      viewModel.targetTitle = newValue
    default: break
    }
  }
  
  @IBAction func tapSaveTargetButton(_ sender: Any) {
    viewModel.createTarget()
  }
}

extension TargetFormViewController: TargetFormViewModelDelegate, TargetActionsDelegate {
  func newMatchFound(match: Match) {
    delegate?.newMatchFound(match: match)
  }
  
  func newTargetCreated(match: Match) {
    delegate?.newTargetCreated(match: match)
    dismiss(animated: true, completion: {
      if match.user != nil, match.conversation?.topicId != nil {
        self.newMatchFound(match: match)
      }
    })
  }
  
  func didUpdateState() {
    UIApplication.toggleNetworkActivity(viewModel.state == .loading)
    if case .error(let description) = viewModel.state {
      showMessage(title: "Error", message: description)
    }
  }
  
  func formDidChange() {
    createTargetButton.enable(viewModel.hasValidData)
  }
}

extension TargetFormViewController: TopicViewModelDelegate {
  func topicSelected(at: Int) {
    let topic = viewModel.topics[at]
    selectTopicButton.setTitle(topic.label.uppercased(), for: .normal)
    selectTopicButton.setImage(topic.image?.withRenderingMode(.alwaysTemplate),
                               for: .normal)
    selectTopicButton.tintColor = .black
    selectTopicButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    selectTopicButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    if let id = topic.id {
      viewModel.targetTopic = id
    }
  }
}
