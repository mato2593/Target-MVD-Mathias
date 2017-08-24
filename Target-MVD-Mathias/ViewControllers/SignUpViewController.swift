//
//  SignUpViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var genderTextField: UITextField!
  
  @IBOutlet weak var nameErrorLabel: UILabel!
  @IBOutlet weak var emailErrorLabel: UILabel!
  @IBOutlet weak var passwordErrorLabel: UILabel!
  @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
  @IBOutlet weak var genderErrorLabel: UILabel!
  
  // MARK: Constants
  let minPasswordLength = 8
  let genderPickerView = UIPickerView()
  let genderValues = ["MALE", "FEMALE"]
  
  // MARK: Variables
  var errorsInForm = false
  var firstTimeOpeningPicker = true
  var firstTimeEditingPassword = true
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
  }
  
  private func setupView() {
    nameTextField.delegate = self
    emailTextField.delegate = self
    passwordTextField.delegate = self
    confirmPasswordTextField.delegate = self
    
    genderPickerView.dataSource = self
    genderPickerView.delegate = self
    
    genderTextField.inputView = genderPickerView
    genderTextField.attributedPlaceholder = NSAttributedString(string: "SELECT YOUR GENDER", attributes: [NSForegroundColorAttributeName: UIColor.black])
    genderTextField.delegate = self
  }
  
  // MARK: Actions
  @IBAction func tapOnSignUpButton(_ sender: Any) {
    if errorsInForm {
      resetErrors()
    }
    
    if formDataIsValid() {
      showSpinner()
      signUp()
    } else {
      errorsInForm = true
    }
  }
  
  @IBAction func tapOnSignInButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: Private methods
  private func resetErrors() {
    let textFields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, genderTextField]
    let errorLabels = [nameErrorLabel, emailErrorLabel, passwordErrorLabel, confirmPasswordErrorLabel, genderErrorLabel]
    
    for i in 0..<textFields.count {
      UIHelper.hideErrorInForm(textField: textFields[i]!, errorLabel: errorLabels[i]!)
    }
    
    errorsInForm = false
  }
  
  private func formDataIsValid() -> Bool {
    var result = true
    
    if nameIsInvalid() {
      result = false
      UIHelper.showErrorInForm(textField: nameTextField, errorLabel: nameErrorLabel)
    }
    
    if emailIsInvalid() {
      result = false
      UIHelper.showErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
    }
    
    if passwordIsInvalid() {
      result = false
      UIHelper.showErrorInForm(textField: passwordTextField, errorLabel: passwordErrorLabel)
    } else if confirmPasswordIsInvalid() {
      result = false
      UIHelper.showErrorInForm(textField: confirmPasswordTextField, errorLabel: confirmPasswordErrorLabel)
    }
    
    if genderIsInvalid() {
      result = false
      UIHelper.showErrorInForm(textField: genderTextField, errorLabel: genderErrorLabel)
    }
    
    return result
  }
  
  private func signUp() {
    let name = nameTextField.text!
    let email = emailTextField.text!
    let password = passwordTextField.text!
    let gender = genderTextField.text!
    
    UserAPI.signup(name: name, email: email, password: password, gender: gender, success: { (_) in
      self.hideSpinner()
      UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateInitialViewController()
    }) { (error) in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error.domain.capitalizeFirstLetter())
    }
  }
  
  fileprivate func nameIsInvalid() -> Bool {
    let name = nameTextField.text!
    return name.isEmpty
  }
  
  fileprivate func emailIsInvalid() -> Bool {
    let email = emailTextField.text!
    return !email.isEmailFormatted()
  }
  
  fileprivate func passwordIsInvalid() -> Bool {
    let password = passwordTextField.text!
    return password.length() < minPasswordLength
  }
  
  fileprivate func confirmPasswordIsInvalid() -> Bool {
    let password = passwordTextField.text!
    let confirmPassword = confirmPasswordTextField.text!
    
    return confirmPassword != password
  }
  
  fileprivate func genderIsInvalid() -> Bool {
    let gender = genderTextField.text!
    return gender.isEmpty
  }
  
}

extension SignUpViewController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return genderValues[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    genderTextField.text = genderValues[row]
  }
  
}

extension SignUpViewController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return genderValues.count
  }
  
}

extension SignUpViewController: UITextFieldDelegate {
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if firstTimeOpeningPicker && textField == genderTextField {
      firstTimeOpeningPicker = false
      genderPickerView.selectRow(0, inComponent: 0, animated: false)
      pickerView(genderPickerView, didSelectRow: 0, inComponent: 0)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
      case nameTextField:
        UIHelper.toggleErrorInForm(error: nameIsInvalid(), textField: nameTextField, errorLabel: nameErrorLabel)
      case emailTextField:
        UIHelper.toggleErrorInForm(error: emailIsInvalid(), textField: emailTextField, errorLabel: emailErrorLabel)
      case passwordTextField, confirmPasswordTextField:
        checkPasswordErrors()
        
        firstTimeEditingPassword = textField != passwordTextField
        
        if textField == passwordTextField {
          firstTimeEditingPassword = false
        }
      case genderTextField:
        UIHelper.toggleErrorInForm(error: genderIsInvalid(), textField: genderTextField, errorLabel: genderErrorLabel)
      default:
        break
    }
  }
  
  fileprivate func checkPasswordErrors() {
    if passwordIsInvalid() {
      UIHelper.showErrorInForm(textField: passwordTextField, errorLabel: passwordErrorLabel)
    } else {
      UIHelper.hideErrorInForm(textField: passwordTextField, errorLabel: passwordErrorLabel)
      
      let confirmPasswordError = confirmPasswordIsInvalid() && !firstTimeEditingPassword
      UIHelper.toggleErrorInForm(error: confirmPasswordError, textField: confirmPasswordTextField, errorLabel: confirmPasswordErrorLabel)
    }
  }
  
}
