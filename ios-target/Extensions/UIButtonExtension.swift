//
//  UIButtonExtension.swift
//  ios-target
//
//  Created by sol manini on 7/1/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  
  func enable(_ enable: Bool) {
    alpha = enable ? 1 : 0.5
    isEnabled = enable
  }
}
