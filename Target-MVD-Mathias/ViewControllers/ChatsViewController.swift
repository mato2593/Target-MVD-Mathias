//
//  ChatsViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  // MARK: Actions
  @IBAction func tapOnMapBarButtonItem(_ sender: Any) {
    var homeViewController: HomeViewController?
    
    if let viewControllers = navigationController?.viewControllers {
      for viewController in viewControllers {
        if let viewController = viewController as? HomeViewController {
          viewController.removeFromParentViewController()
          homeViewController = viewController
        }
      }
    }
    
    if homeViewController == nil {
      homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    }
    
    let transition = CATransition()
    transition.duration = 0.35
    transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    transition.type = kCATransitionPush
    transition.subtype = kCATransitionFromLeft
    
    navigationController!.view.layer.add(transition, forKey: kCATransition)
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
}
