//
//  TopicsViewController.swift
//  ios-target
//
//  Created by sol manini on 7/1/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class TopicsViewController: ModalViewController {
  
  @IBOutlet weak var topicsCollectionHeightContraint: NSLayoutConstraint!
  @IBOutlet weak var topicsCollectionView: UICollectionView!
  
  var viewModel = TopicsViewModel()
  
  weak var delegate: TopicViewModelDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setupView()
  }
  
  func setupView() {
    topicsCollectionHeightContraint.constant = CGFloat(self.viewModel.collectionHeight)
    topicsCollectionView.register(UINib(nibName: TopicsCollectionViewCell.reuseIdentifier,
                                        bundle: nil), forCellWithReuseIdentifier: TopicsCollectionViewCell.reuseIdentifier)
    topicsCollectionView.dataSource = self
    topicsCollectionView.delegate = self
  }
}

extension TopicsViewController: TopicViewModelDelegate {
  func topicSelected(topic: Topic) {
    delegate?.topicSelected(topic: topic)
  }
  
  func didUpdateState() {
    if viewModel.state == .loading {
      UIApplication.showNetworkActivity()
    } else {
      UIApplication.hideNetworkActivity()  
    }
    
    if case .error(let errorDescription) = viewModel.state {
      showMessage(title: "Error", message: errorDescription)
    }
  }  
}

extension TopicsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.topicsCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicsCollectionViewCell.reuseIdentifier, for: indexPath)
    
    if let cell = cell as? TopicsCollectionViewCell {
      let topic = viewModel.topics[indexPath.item]
      cell.topic = topic
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let topic = viewModel.topics[indexPath.item]
    delegate?.topicSelected(topic: topic)
    dismiss(animated: true)
  }
}

extension TopicsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: CGFloat(viewModel.cellHeight))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
