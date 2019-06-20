//
//  ViewController.swift
//  ios-target
//
//  Created by Rootstrap on 15/2/16.
//  Copyright © 2016 Rootstrap. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var facebookSign: UIButton!
  @IBOutlet weak var signIn: UIButton!
  @IBOutlet weak var signUp: UIButton!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  
  var viewModel = FirstViewModel()

  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.delegate = self
    setBackground()
  }
  
  func setBackground() {
    backgroundImage.image = UIImage(named: "background-main")
    backgroundImage.contentMode = .scaleAspectFill
    view.bringSubviewToFront(titleLabel)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Actions
  
  @IBAction func facebookLogin() {
    viewModel.facebookLogin()
  }
}

extension FirstViewController: FirstViewModelDelegate {
  func didUpdateState() {
    switch viewModel.state {
    case .loading:
      UIApplication.showNetworkActivity()
    case .idle:
      UIApplication.hideNetworkActivity()
    case .error(let errorDescription):
      UIApplication.hideNetworkActivity()
      showMessage(title: "Oops", message: errorDescription)
    case .facebookLoggedIn:
      UIApplication.hideNetworkActivity()
      performSegue(withIdentifier: "goToMainView", sender: nil)
    }
  }
}
