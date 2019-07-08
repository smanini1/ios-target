//
//  UIImageViewExtension.swift
//  ios-target
//
//  Created by sol manini on 7/4/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
  func setImage(with url: URL?, placeholder: String) {
    sd_setImage(with: url, placeholderImage: UIImage(named: placeholder), options: .refreshCached)
  }
}
