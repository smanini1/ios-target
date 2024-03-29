//
//  UIColorExtension.swift
//  ios-target
//
//  Created by sol manini on 6/25/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

extension UIColor {
  
  static let brownGrey = UIColor(white: 166.0 / 255.0, alpha: 1.0)
  static let macaroniAndCheese70 = UIColor(red: 239.0 / 255.0, green: 197.0 / 255.0, blue: 55.0 / 255.0, alpha: 0.7)
  static let codGray = UIColor(red: 223, green: 222, blue: 223)
  static let macaroniAndCheese = UIColor(red: 240, green: 199, blue: 56)
  static let scarlet = UIColor(red: 208, green: 1, blue: 27)
  static let brownGreyTwo = UIColor(white: 175.0 / 255.0, alpha: 1.0)
  static let white70 = UIColor(white: 245.0 / 255.0, alpha: 0.7)
  static let darkSkyBlue70 = UIColor(red: 47.0 / 255.0, green: 188.0 / 255.0, blue: 247.0 / 255.0, alpha: 0.7)
  
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: min(CGFloat(red), 255.0) / 255.0,
              green: min(CGFloat(green), 255.0) / 255.0,
              blue: min(CGFloat(blue), 255.0) / 255.0,
              alpha: 1.0)
  }
}
