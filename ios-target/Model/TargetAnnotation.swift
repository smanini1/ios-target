//
//  TargetAnnotation.swift
//  ios-target
//
//  Created by sol manini on 6/21/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit
import MapKit

enum TargetType: Int {
  case christmas = 0
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
    switch self {
    case .christmas:
      return UIImage(named: "christmas-pin") ?? UIImage()
    case .pokemon:
      return UIImage(named: "pokemon-pin") ?? UIImage()
    case .football:
      return UIImage(named: "christmas-pin") ?? UIImage()
    case .travel:
      return UIImage(named: "travel-pin") ?? UIImage()
    case .politics:
      return UIImage(named: "politics-pin") ?? UIImage()
    case .art:
      return UIImage(named: "art-pin") ?? UIImage()
    case .dating:
      return UIImage(named: "dating-pin") ?? UIImage()
    case .music:
      return UIImage(named: "music-pin") ?? UIImage()
    case .movies:
      return UIImage(named: "movies-pin") ?? UIImage()
    case .series:
      return UIImage(named: "series-pin") ?? UIImage()
    case .food:
      return UIImage(named: "food-pin") ?? UIImage()
    }
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
