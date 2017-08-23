//
//  UserProfileViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/21/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import SDWebImage

class UserProfileViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var avatarImageView: UIImageView!
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var usernameErrorLabel: UILabel!
  @IBOutlet weak var emailErrorLabel: UILabel!
  
  @IBOutlet weak var saveChangesButton: UIButton!
  
  // MARK: Variables
  var imageChanged = false
  var usernameChanged = false
  var emailChanged = false
  var passwordChanged = false
  
  var username: String = ""
  var email: String = ""
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationBar()
    
    setupView()
    
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
      self.showMessageError(title: "Error", errorMessage: error.domain)
    }
  }
  
  @IBAction func tapOnSaveChangesButton(_ sender: Any) {
    self.showSpinner()
    
    UserAPI.updateUser(
      id: "\(UserDataManager.getUserId())",
      name: usernameChanged ? usernameTextField.text : nil,
      email: emailChanged ? emailTextField.text : nil,
      password: passwordChanged ? passwordTextField.text : nil,
      avatar64: imageChanged ? avatarImageView.image : nil,
      success: {
        self.hideSpinner()
        self.disableSaveChangesButton()
      }) { (error) in
        self.showMessageError(title: "Error", errorMessage: error.domain)
      }
  }
  
  // MARK: Functions
  func setupNavigationBar() {
    let goBackToHomeNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ForwardArrow"), style: .plain, target: self, action:#selector(UserProfileViewController.goBackToHome))
    goBackToHomeNavigationItem.tintColor = .black
    
    navigationItem.setRightBarButton(goBackToHomeNavigationItem, animated: false)
    
    makeNavigationBarTransparent()
  }
  
  func setupView() {
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
    avatarImageView.layer.masksToBounds = true
    
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "********", attributes: [NSForegroundColorAttributeName: UIColor.black])
    
    disableSaveChangesButton()
  }
  
  func getUserData() {
    let user = UserDataManager.getUserObject()
    
    usernameTextField.text = user?.username
    emailTextField.text = user?.email
    avatarImageView.sd_setImage(with: user?.image)
    
    username = user?.username ?? ""
    email = user?.email ?? ""
  }
  
  func disableSaveChangesButton() {
    saveChangesButton.isEnabled = false
    saveChangesButton.layer.backgroundColor = UIColor.gray.cgColor
  }
  
  func enableSaveChangesButton() {
    saveChangesButton.isEnabled = true
    saveChangesButton.layer.backgroundColor = UIColor.black.cgColor
  }
  
  func goBackToHome() {
    let homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
}

extension UserProfileViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
    case usernameTextField:
      usernameChanged = usernameTextField.text != username
    case emailTextField:
      emailChanged = emailTextField.text != email
    default:
      break
    }
    
    let dataChanged = usernameChanged || emailChanged
    dataChanged ? enableSaveChangesButton() : disableSaveChangesButton()
  }
  
}
