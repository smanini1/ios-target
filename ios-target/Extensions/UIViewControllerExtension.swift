//
//  UIViewControllerExtension.swift
//  ios-target
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  // MARK: - Message Error
  func showMessage(title: String,
                   message: String,
                   cancelOption: String? = nil,
                   handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok".localized, style: UIAlertAction.Style.default, handler: handler))
    if cancelOption != nil {
      alert.addAction(UIAlertAction(title: cancelOption, style: .cancel))
    }
    present(alert, animated: true, completion: nil)
  }
  
  func goToScreen(withIdentifier identifier: String,
                  storyboardId: String? = nil,
                  modally: Bool = false,
                  viewControllerConfigurationBlock: ((UIViewController) -> Void)? = nil) {
    var storyboard = self.storyboard
    
    if let storyboardId = storyboardId {
      storyboard = UIStoryboard(name: storyboardId, bundle: nil)
    }
    
    guard let viewController =
      storyboard?.instantiateViewController(withIdentifier: identifier) else {
        assert(false, "No view controller found with that identifier".localized)
        return
    }
    
    viewControllerConfigurationBlock?(viewController)
    
    if modally {
      present(viewController, animated: true)
    } else {
      assert(navigationController != nil, "navigation controller is nil".localized)
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
}
