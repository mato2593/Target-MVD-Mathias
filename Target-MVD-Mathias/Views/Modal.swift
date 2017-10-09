//
//  Modal.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

protocol Modal {
  var backgroundView: UIView! { get }
  var dialogView: UIView! { get set }
  
  func show(animated: Bool)
  func dismiss(animated: Bool)
}

extension Modal where Self: UIView {
  
  func show(animated: Bool) {
    self.backgroundView.alpha = 0
    UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)
    
    self.dialogView.layoutIfNeeded()
    self.backgroundView.layoutIfNeeded()
    self.layoutIfNeeded()
    
    self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height / 2)
    
    if animated {
      UIView.animate(withDuration: 0.35) {
        self.backgroundView.alpha = 0.4
      }
      UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
        self.dialogView.center  = self.center
      }, completion: nil)
    } else {
      self.backgroundView.alpha = 0.4
      self.dialogView.center  = self.center
    }
  }
  
  func dismiss(animated: Bool) {
    if animated {
      UIView.animate(withDuration: 0.35) {
        self.backgroundView.alpha = 0
      }
      UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
        self.dialogView.center = CGPoint(x: self.center.x, y: self.frame.height + self.dialogView.frame.height/2)
      }, completion: { _ in
        self.removeFromSuperview()
      })
    } else {
      self.removeFromSuperview()
    }
  }
}
