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
  
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var signInErrorLabel: UILabel!
  
  // MARK: Constants
  let minPasswordLength = 8
  let signInErrorMessage = "this email and password don’t match"
  let passwordErrorMessage = "the password must be 8 characters long"
  
  // MARK: Variables
  var signInError = false
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
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
  
  // MARK: Private functions\
  private func errorsInForm() -> Bool {
    return emailIsInvalid() || passwordIsInvalid()
  }
  
  private func showErrorsInForm() {
    toggleErrorInForm(error: emailIsInvalid(), textField: emailTextField, errorLabel: emailErrorLabel)
    toggleErrorInForm(error: passwordIsInvalid(), textField: passwordTextField, errorLabel: signInErrorLabel, errorMessage: passwordErrorMessage)
  }
  
  private func signIn() {
    showSpinner()
    
    if signInError {
      resetErrors()
    }
    
    let email = emailTextField.text!
    let password = passwordTextField.text!
    
    UserAPI.login(email, password: password, success: { (_) in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateViewController(HomeViewController.self, storyboardIdentifier: "Onboarding")
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
