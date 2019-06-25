//
//  TargetCircle.swift
//  ios-target
//
//  Created by sol manini on 6/25/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import MapKit

class TargetCircle: MKCircle {
  
  var backgroundColor: UIColor?
  var borderColor: UIColor?
  
  convenience init(radius: Double,
                   backgroundColor: UIColor,
                   borderColor: UIColor,
                   coordinates: CLLocationCoordinate2D) {
    self.init(center: coordinates, radius: radius)
    self.borderColor = borderColor
    self.backgroundColor = backgroundColor
  }
}