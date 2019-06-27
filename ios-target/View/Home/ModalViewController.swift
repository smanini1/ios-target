//
//  TargetForm.swift
//  ios-target
//
//  Created by sol manini on 6/17/19.
//  Copyright © 2019 TopTier labs. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {
  
  lazy var blackView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.alpha = 0
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.insertSubview(blackView, at: 0)
    
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: blackView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: blackView.trailingAnchor),
      view.widthAnchor.constraint(equalTo: blackView.widthAnchor),
      view.heightAnchor.constraint(equalTo: blackView.heightAnchor)
      ])
    
    blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    dimBackground(isSet: false)
  }
  
  func dimBackground(isSet: Bool = false, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: isSet ? 0.2 : 0.3,
                   animations: {
                    self.blackView.alpha = isSet ? 0 : 1
    }, completion: completion)
  }
  
  @objc
  func handleDismiss() {
    dismiss(animated: true)
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    dimBackground(isSet: true, completion: { _ in
      super.dismiss(animated: flag)
    })
  }
}
