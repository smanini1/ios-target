//
//  TargetAnnotation.swift
//  ios-target
//
//  Created by sol manini on 6/21/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import MapKit

enum TargetType: String {
  case christmas
  case pokemon
  case football
  case travel
  case politics
  case art
  case dating
  case music
  case movies
  case series
  case food
  
  func image() -> UIImage {
    let imageName = self.rawValue + "-pin"
    return UIImage(named: imageName) ?? UIImage()
  }
}

class TargetAnnotation: NSObject, MKAnnotation {
  var id: Int?
  var coordinate: CLLocationCoordinate2D
  var type: TargetType
  var target: Target
  
  init(id: Int, coordinate: CLLocationCoordinate2D, type: TargetType, target: Target) {
    self.id = id
    self.coordinate = coordinate
    self.type = type
    self.target = target
  }
}
