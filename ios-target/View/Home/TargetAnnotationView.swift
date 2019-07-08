//
//  TargetAnnotationView.swift
//  ios-target
//
//  Created by sol manini on 6/24/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import MapKit

class TargetAnnotationView: MKAnnotationView {
  
  static let reuseIdentifier = "TargetAnnotationView"
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
    super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    guard let targetAnnotation = self.annotation as? TargetAnnotation else { return }
  
    image = targetAnnotation.type.image()
  }
}
