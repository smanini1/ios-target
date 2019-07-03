//
//  TopicsCollectionViewCell.swift
//  ios-target
//
//  Created by sol manini on 7/2/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class TopicsCollectionViewCell: UICollectionViewCell {
  
  static var reuseIdentifier = "TopicsCollectionViewCell"
  
  @IBOutlet weak var topicLabel: UILabel!
  @IBOutlet weak var topicImage: UIImageView!
  
  var topic: Topic? {
    didSet {
      if let label = topic?.label,
        let image = topic?.image {
        topicLabel.text = label
        topicImage.image = image
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
