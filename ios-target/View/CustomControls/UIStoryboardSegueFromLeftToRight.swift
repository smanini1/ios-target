//
//  UIStoryboardSegueFromLeftToRight.swift
//  ios-target
//
//  Created by sol manini on 7/10/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

class UIStoryboardSegueFromLeftToRight: UIStoryboardSegue {
  
  override func perform() {
    let animationDuration = 0.35
    let sourceController = source as UIViewController
    let destinationController = destination as UIViewController
    
    sourceController.view.superview?.insertSubview(destinationController.view,
                                                   aboveSubview: sourceController.view)
    destinationController.view.transform = CGAffineTransform(translationX: -sourceController.view.frame.size.width,
                                                             y: 0)
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
                    destinationController.view.transform = CGAffineTransform(translationX: 0,
                                                                             y: 0)
    },
                   completion: { _ in
                    sourceController.present(destinationController,
                                             animated: false,
                                             completion: nil)
    })
  }
}

class UIStoryboardUnwindSegueFromLeftToRight: UIStoryboardSegue {
  
  override func perform() {
    let animationDuration = 0.35
    let sourceController = source as UIViewController
    let destinationController = destination as UIViewController
    
    sourceController.view.superview?.insertSubview(destinationController.view,
                                                   belowSubview: sourceController.view)
    sourceController.view.transform = CGAffineTransform(translationX: 0,
                                                        y: 0)
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
                    sourceController.view.transform = CGAffineTransform(translationX: -sourceController.view.frame.size.width,
                                                                        y: 0)
    },
                   completion: { _ in
                    sourceController.dismiss(animated: false,
                                             completion: nil)
    })
  }
}

class UIStoryboardSegueFromRightToLeft: UIStoryboardSegue {
  
  override func perform() {
    let animationDuration = 0.35
    let sourceController = source as UIViewController
    let destinationController = destination as UIViewController
    
    sourceController.view.superview?.insertSubview(destinationController.view,
                                                   aboveSubview: sourceController.view)
    destinationController.view.transform = CGAffineTransform(translationX: sourceController.view.frame.size.width,
                                                             y: 0)
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
                    destinationController.view.transform = CGAffineTransform(translationX: 0,
                                                                             y: 0)
    },
                   completion: { _ in
                    sourceController.present(destinationController,
                                             animated: false,
                                             completion: nil)
    })
  }
}

class UIStoryboardUnwindSegueFromRightToLeft: UIStoryboardSegue {
  
  override func perform() {
    let animationDuration = 0.35
    let sourceController = source as UIViewController
    let destinationController = destination as UIViewController
    
    sourceController.view.superview?.insertSubview(destinationController.view,
                                                   belowSubview: sourceController.view)
    sourceController.view.transform = CGAffineTransform(translationX: 0,
                                                        y: 0)
    
    UIView.animate(withDuration: animationDuration,
                   delay: 0.0,
                   options: .curveEaseInOut,
                   animations: {
                    sourceController.view.transform = CGAffineTransform(translationX: sourceController.view.frame.size.width,
                                                                        y: 0)
    },
                   completion: { _ in
                    sourceController.dismiss(animated: false,
                                             completion: nil)
    })
  }
}
