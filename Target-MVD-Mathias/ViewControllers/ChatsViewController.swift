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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == "ChatsToUserProfile" {
      if let viewControllers = navigationController?.viewControllers {
        for viewController in viewControllers {
          if let viewController = viewController as? UserProfileViewController {
            viewController.removeFromParentViewController()
          }
        }
      }
    }
  }
  
  // MARK: Actions
  @IBAction func tapOnMapBarButtonItem(_ sender: Any) {
    var homeViewController = getViewControllerFromNavigationStack(type: HomeViewController.self)
    
    if homeViewController == nil {
      homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    }
    
    navigationController?.setPushFromLeftTransition()
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
}
