//
//  SignInViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signInErrorLabel: UILabel!
  
  // MARK: Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    showSpinner()
    
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    UserAPI.login(email, password: password, success: { (responseObject) in
      self.hideSpinner()
      print(responseObject!)
      UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateViewController(HomeViewController.self, storyboardIdentifier: "Onboarding")
    }) { (error) in
      self.hideSpinner()
      self.showSignInError()
      print(error)
    }
  }
  
  // MARK: Private functions
  private func showSignInError() {
    signInErrorLabel.isHidden = false
  }
}
