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
  var coordinate: CLLocationCoordinate2D
  var title: String?
  var subtitle: String?
  var type: TargetType
  var radius: Double
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, type: TargetType, radius: Double) {
    self.coordinate = coordinate
    self.title = title
    self.subtitle = subtitle
    self.type = type
    self.radius = radius
  }
}
