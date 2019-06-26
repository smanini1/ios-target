//
//  LeftSlideAnimationController.swift
//  talkative-iOS
//
//  Created by German Lopez on 2/24/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

enum SlideDirection {
  case left
  case above
  case down
  case right
  
  func isHorizontal() -> Bool {
    return self == .left || self == .right
  }
}

enum SlideEffect {
  case over
  case moveOut
}

class SlideAnimationController: UIPercentDrivenInteractiveTransition {
  
  var dismissalThreshold: CGFloat = 0.35
  var presenting = true
  var slideDuration = 0.35
  fileprivate var _proportion: CGFloat = 0.75
  var menuProportion: CGFloat {
    set {
      _proportion = newValue > 1 ? 1 : newValue < 0 ? 0.75 : newValue
    }
    get {
      return _proportion
    }
  }
  var animationEffect: SlideEffect = .moveOut
  fileprivate var _dim: CGFloat = 0.5
  //Opacity of the original view controller [0,1], 0: indicates view fully visible, 1: indicates view invisible
  var dimLevel: CGFloat {
    set {
      _dim = newValue > 1 ? 1 : newValue < 0 ? 1 : newValue
    }
    get {
      return _dim
    }
  }
  
  var direction: SlideDirection = .down
  var inProgress = false
  fileprivate weak var originalView: UIView?
  fileprivate weak var menuView: UIView!
  fileprivate weak var wiredViewController: UIViewController?
  
  fileprivate var shouldComplete = false
  
  convenience init (withEffect effect: SlideEffect = .moveOut, proportion: CGFloat = 0.75, from direction: SlideDirection = .left, duration: TimeInterval = 0.35, presenting: Bool = true, dismissalThreshold: CGFloat = 0.35, dimLevel: CGFloat = 0.5) {
    self.init()
    self.presenting = presenting
    self.direction = direction
    self.animationEffect = effect
    self.dismissalThreshold = dismissalThreshold
    self.dimLevel = dimLevel
    self.slideDuration = duration
    self.menuProportion = proportion
  }
  
  func wireTo(viewController controller: UIViewController) {
    wiredViewController = controller
    wiredViewController?.modalPresentationStyle = .overCurrentContext
  }
  
  private func prepareGestureRecognizer(inView view: UIView) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    pan.cancelsTouchesInView = true
    view.addGestureRecognizer(pan)
  }
  
  func menuInitialFrame(from originalFrame: CGRect) -> CGRect {
    var ratio = originalFrame.size.width * menuProportion
    let screenBounds = UIScreen.main.bounds
    switch direction {
    case .left:
      return CGRect(x: -ratio, y: 0, width: ratio, height: originalFrame.size.height)
    case .right:
      return CGRect(x: screenBounds.size.width, y: 0, width: ratio, height: originalFrame.size.height)
    case .above:
      ratio = originalFrame.size.height * menuProportion
      return CGRect(x: 0, y: -ratio, width: originalFrame.size.width, height: ratio)
    case .down:
      ratio = originalFrame.size.height * menuProportion
      return CGRect(x: 0, y: screenBounds.size.height, width: originalFrame.size.width, height: ratio)
    default:
      return originalFrame
    }
  }
  
  func finalFrames(forMain mainView: UIView, andMenu menuView: UIView, withRatio ratioSize: CGFloat) -> (main: CGRect, menu: CGRect) {
    let screenBounds = UIScreen.main.bounds
    var frames: (main: CGRect, menu: CGRect) = (mainView.frame, menuView.frame)
    switch direction {
    case .left:
      frames.main = CGRect(x: presenting ? ratioSize : 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height)
      frames.menu = CGRect(x: presenting ? 0 : -ratioSize, y: 0, width: ratioSize, height: menuView.frame.size.height)
    case .right:
      frames.main = CGRect(x: presenting ? -ratioSize : 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height)
      frames.menu = CGRect(x: presenting ? screenBounds.size.width-ratioSize : screenBounds.size.width, y: 0, width: ratioSize, height: menuView.frame.size.height)
    case .above:
      frames.main = CGRect(x: 0, y: presenting ? ratioSize : 0, width: mainView.frame.size.width, height: mainView.frame.size.height)
      frames.menu = CGRect(x: 0, y: presenting ? 0 : -ratioSize, width: menuView.frame.size.width, height: ratioSize)
    default:  //.down
      frames.main = CGRect(x: 0, y: presenting ? -ratioSize : 0, width: mainView.frame.size.width, height: mainView.frame.size.height)
      frames.menu = CGRect(x: 0, y: presenting ? screenBounds.size.height - ratioSize : screenBounds.size.height, width: menuView.frame.size.width, height: ratioSize)
    }
    return frames
  }
  
  @objc func handlePanGesture(pan: UIPanGestureRecognizer) {
    guard let view = pan.view else { return }
    let size = direction.isHorizontal() ? view.frame.width : view.frame.height
    switch pan.state {
    case .began:
      inProgress = true
      wiredViewController?.dismiss(animated: true, completion: nil)
    case .changed:
      let progress = getProgress(from: pan.translation(in: view))
      let normalized = progress > size ? 1 : progress / size
      shouldComplete = normalized > dismissalThreshold
      update(normalized)
    case .cancelled:
      inProgress = false
      cancel()
    case .ended:
      inProgress = false
      if shouldComplete {
        finish()
      } else {
        cancel()
      }
    default: break
    }
  }
  
  private func getProgress(from translation: CGPoint) -> CGFloat {
    switch direction {
    case .left:
      return translation.x >= 0 ? 0 : abs(translation.x)
    case .above:
      return translation.y >= 0 ? 0 : abs(translation.y)
    case .right:
      return translation.x <= 0 ? 0 : translation.x
    default:
      return translation.y <= 0 ? 0 : translation.y
    }
  }
  
  @objc func closeMenu(tap: UITapGestureRecognizer) {
    wiredViewController?.dismiss(animated: true, completion: nil)
  }
}

extension SlideAnimationController: UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return slideDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
      let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
        return
    }
    let menuView: UIView = presenting ? toVC.view : fromVC.view
    let mainView: UIView = presenting ? fromVC.view : toVC.view
    self.menuView = menuView
    
    var ratioSize = direction.isHorizontal() ? menuView.frame.size.width : menuView.frame.size.height
    
    let containerView = transitionContext.containerView
    
    if presenting {
      ratioSize *= menuProportion
      menuView.frame = menuInitialFrame(from: menuView.frame)
      originalView = mainView.superview
      containerView.addSubview(menuView)
      containerView.addSubview(mainView)
      containerView.bringSubviewToFront(menuView)
      let tapToExit = UITapGestureRecognizer(target: self, action: #selector(closeMenu))
      tapToExit.numberOfTapsRequired = 1
      tapToExit.delegate = self
      containerView.addGestureRecognizer(tapToExit)
      let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
      containerView.addGestureRecognizer(pan)
    }
    
    let duration = transitionDuration(using: transitionContext)
    let frames = finalFrames(forMain: mainView, andMenu: menuView, withRatio: ratioSize)
    
    UIView.animate(withDuration: duration, delay: 0,
                   options: presenting ? .curveEaseOut : .curveEaseInOut,
                   animations: {
                    if self.animationEffect == .moveOut {
                      mainView.frame = frames.main
                    }
                    
                    menuView.frame = frames.menu
                    mainView.alpha = self.presenting ? 1 - self.dimLevel : 1
    }) { _ in
      mainView.isUserInteractionEnabled = !self.presenting && !transitionContext.transitionWasCancelled
      if !self.presenting && !transitionContext.transitionWasCancelled {
        self.originalView?.addSubview(mainView)
      }
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}

extension SlideAnimationController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard let tap = gestureRecognizer as? UITapGestureRecognizer else { return true }
    return !self.menuView.frame.contains(tap.location(ofTouch: 0, in: originalView))
  }
}
