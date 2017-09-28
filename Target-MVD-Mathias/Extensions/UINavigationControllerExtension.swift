//
//  UINavigationControllerExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/25/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
  
  func setPushFromLeftTransition() {
    let transition = CATransition()
    transition.duration = 0.35
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    
    view.layer.add(transition, forKey: kCATransition)
  }
}
