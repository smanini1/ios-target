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
      view.topAnchor.constraint(equalTo: blackView.topAnchor),
      view.bottomAnchor.constraint(equalTo: blackView.bottomAnchor)
      ])
    
    blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    darkenBackground(show: true)
  }
  
  func darkenBackground(show: Bool = false, completion: ((Bool) -> Void)? = nil) {
    UIView.animate(withDuration: show ? 0.3 : 0.2,
                   animations: {
                    self.blackView.alpha = show ? 1 : 0
    }, completion: completion)
  }
  
  @objc
  func handleDismiss() {
    dismiss(animated: true)
  }
  
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    darkenBackground(show: false, completion: { _ in
      super.dismiss(animated: flag, completion: completion)
    })
  }
}
