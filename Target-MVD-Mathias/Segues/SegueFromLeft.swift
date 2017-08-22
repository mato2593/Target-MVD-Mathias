//
//  SegueFromLeft.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
  
  override func perform() {
    let transition: CATransition = CATransition()

    transition.duration = 0.35
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    
    source.navigationController!.view.layer.add(transition, forKey: kCATransition)
    source.navigationController!.pushViewController(destination, animated: false)
  }
  
}
