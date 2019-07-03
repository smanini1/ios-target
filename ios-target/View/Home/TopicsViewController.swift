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
  var cellHeight = 50
  
  var collectionHeight: Int {
    return viewModel.topicsCount * cellHeight + cellHeight
  }
  
  weak var delegate: TopicViewModelDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setupView()
  }
  
  func setupView() {
    topicsCollectionHeightContraint.constant = CGFloat(collectionHeight)
    topicsCollectionView.register(UINib(nibName: TopicsCollectionViewCell.reuseIdentifier,
                                        bundle: nil), forCellWithReuseIdentifier: TopicsCollectionViewCell.reuseIdentifier)
    topicsCollectionView.dataSource = self
    topicsCollectionView.delegate = self
  }
}

extension TopicsViewController: TopicViewModelDelegate {
  func topicSelected(at: Int) {
    delegate?.topicSelected(at: at)
  }
}

extension TopicsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.topicsCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicsCollectionViewCell.reuseIdentifier,
                                                  for: indexPath)
    
    if let cell = cell as? TopicsCollectionViewCell {
      let topic = viewModel.topics[indexPath.item]
      cell.topic = topic
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.topicSelected(at: indexPath.item)
    dismiss(animated: true)
  }
}

extension TopicsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: CGFloat(cellHeight))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
