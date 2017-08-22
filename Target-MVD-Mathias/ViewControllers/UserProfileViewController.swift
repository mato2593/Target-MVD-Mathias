//
//  UserProfileViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/21/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var usernameErrorLabel: UILabel!
  @IBOutlet weak var emailErrorLabel: UILabel!
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationBar()
    
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "********", attributes: [NSForegroundColorAttributeName: UIColor.black])
    
    getUserData()
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
  
  @IBAction func tapOnSaveChangesButton(_ sender: Any) {
    print("SAVE CHANGES")
  }
  
  // MARK: Functions
  func setupNavigationBar() {
    let goBackToHomeNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ForwardArrow"), style: .plain, target: self, action:#selector(UserProfileViewController.goBackToHome))
    goBackToHomeNavigationItem.tintColor = .black
    
    navigationItem.setRightBarButton(goBackToHomeNavigationItem, animated: false)
    
    makeNavigationBarTransparent()
  }
  
  func getUserData() {
    UserAPI.getMyProfile({ (json) in
      print(json)
    }) { (error) in
      print(error)
    }
  }
  
  func goBackToHome() {
    let homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
}
