//
//  UserProfileViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/21/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Actions
  @IBAction func tapOnLogOutButton(_ sender: Any) {
    view.showSpinner(message: "Signing out")
    UserAPI.logout({
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateInitialViewController(storyboardIdentifier: "Onboarding")
    }) { (error) in
      self.hideSpinner()
      print(error)
    }
  }
  
}
