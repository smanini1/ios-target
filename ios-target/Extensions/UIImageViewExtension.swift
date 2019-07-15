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
  
  func setRoundedShape(borderColor: UIColor, borderWidth: CGFloat) {
    layer.borderWidth = 1
    layer.masksToBounds = false
    layer.borderColor = borderColor.cgColor
    layer.cornerRadius = frame.height / 2
    clipsToBounds = true
  }
  
  func cropsToSquare() {
    guard
      let originalImage = image?.cgImage,
      let imageOrientation = image?.imageOrientation
    else { return }
    let imageWidth = CGFloat((originalImage.width))
    let imageHeight = CGFloat((originalImage.height))
    let cropSize = imageWidth > imageHeight ? imageHeight : imageWidth
    
    let x = (imageWidth - cropSize) / 2
    let y = (imageHeight - cropSize) / 2
    
    let cropRectangle = CGRect(x: x, y: y, width: cropSize, height: cropSize)
    if let newImage = originalImage.cropping(to: cropRectangle) {
      image = UIImage(cgImage: newImage, scale: 0.0, orientation: imageOrientation)
    }
  }
}
