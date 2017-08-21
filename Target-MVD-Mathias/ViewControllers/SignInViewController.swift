//
//  SignInViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignInViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var signInErrorLabel: UILabel!
  
  @IBOutlet weak var headerTitleLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var facebookSignInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  // MARK: Constants
  let minPasswordLength = 8
  let signInErrorMessage = "this email and password don’t match"
  let passwordErrorMessage = "the password must be 8 characters long"
  
  // MARK: Variables
  var signInError = false
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setLetterSpacing()
  }
  
  // MARK: Actions
  @IBAction func tapOnSignInButton(_ sender: Any) {
    if errorsInForm() {
      signInError = false
      showErrorsInForm()
    } else {
      signIn()
    }
  }
  
  @IBAction func facebookLogin() {
    showSpinner()
    let fbLoginManager = FBSDKLoginManager()
    //Logs out before login, in case user changes facebook accounts
    fbLoginManager.logOut()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
      guard error == nil else {
        self.showMessageError(title: "Oops..", errorMessage: "Something went wrong, try again later.")
        self.hideSpinner()
        return
      }
      
      if let result = result {
        if result.grantedPermissions == nil || result.isCancelled {
          self.hideSpinner()
        } else if !result.grantedPermissions.contains("email") {
          self.hideSpinner()
          self.showMessageError(title: "Oops..", errorMessage: "It seems that you haven't allowed Facebook to provide your email address.")
        } else {
          self.facebookLoginCallback()
        }
      } else {
        self.hideSpinner()
      }
    }
  }
  
  //MARK: Facebook callback methods
  func facebookLoginCallback() {
    //Optionally store params (facebook user data) locally.
    guard FBSDKAccessToken.current() != nil else {
      return
    }
    UserAPI.loginWithFacebook(token: FBSDKAccessToken.current().tokenString,
                              success: { _ -> Void in
                                self.hideSpinner()
                                UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateInitialViewController()
    }) { (error) -> Void in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error._domain)
    }
  }
  
  // MARK: Private functions
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    headerTitleLabel.setSpacing(ofCharacter: 3.0)
    emailLabel.setSpacing(ofCharacter: defaultSpacing)
    passwordLabel.setSpacing(ofCharacter: defaultSpacing)
    signInButton.titleLabel?.setSpacing(ofCharacter: defaultSpacing)
    facebookSignInButton.titleLabel?.setSpacing(ofCharacter: 2.4)
    signUpButton.titleLabel?.setSpacing(ofCharacter: defaultSpacing)
  }
  
  private func errorsInForm() -> Bool {
    return emailIsInvalid() || passwordIsInvalid()
  }
  
  private func showErrorsInForm() {
    toggleErrorInForm(error: emailIsInvalid(), textField: emailTextField, errorLabel: emailErrorLabel)
    toggleErrorInForm(error: passwordIsInvalid(), textField: passwordTextField, errorLabel: signInErrorLabel, errorMessage: passwordErrorMessage)
  }
  
  private func signIn() {
    showSpinner()
    resetErrors()
    
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    UserAPI.login(email, password: password, success: { (_) in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateInitialViewController()
    }) { (_) in
      self.hideSpinner()
      self.showSignInError()
      self.signInError = true
    }
  }
  
  private func showSignInError() {
    showErrorInForm(textField: emailTextField, errorLabel: nil)
    showErrorInForm(textField: passwordTextField, errorLabel: signInErrorLabel, errorMessage: signInErrorMessage)
  }
  
  private func resetErrors() {
    hideErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
    hideErrorInForm(textField: passwordTextField, errorLabel: signInErrorLabel)
    
    signInError = false
  }
  
  fileprivate func showErrorInForm(textField: UITextField, errorLabel: UILabel?, errorMessage: String = "") {
    textField.addBorder(color: .tomato, weight: 1.5)
    
    if !errorMessage.isEmpty {
      errorLabel?.text = errorMessage
    }
    
    errorLabel?.isHidden = false
  }
  
  fileprivate func hideErrorInForm(textField: UITextField, errorLabel: UILabel) {
    textField.addBorder(color: .black, weight: 1)
    errorLabel.isHidden = true
  }
  
  fileprivate func emailIsInvalid() -> Bool {
    let email = emailTextField.text!
    return !email.isEmailFormatted()
  }
  
  fileprivate func passwordIsInvalid() -> Bool {
    let password = passwordTextField.text!
    return password.length() < minPasswordLength
  }
  
}

extension SignInViewController: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if !signInError {
      switch textField {
      case emailTextField:
        toggleErrorInForm(error: emailIsInvalid(), textField: emailTextField, errorLabel: emailErrorLabel)
      case passwordTextField:
        toggleErrorInForm(error: passwordIsInvalid(), textField: passwordTextField, errorLabel: signInErrorLabel, errorMessage: passwordErrorMessage)
      default:
        break
      }
    }
  }
  
  fileprivate func toggleErrorInForm(error: Bool, textField: UITextField, errorLabel: UILabel, errorMessage: String = "") {
    if error {
      showErrorInForm(textField: textField, errorLabel: errorLabel, errorMessage: errorMessage)
    } else {
      hideErrorInForm(textField: textField, errorLabel: errorLabel)
    }
  }
  
}
