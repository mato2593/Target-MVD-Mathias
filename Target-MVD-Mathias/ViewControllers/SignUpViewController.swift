//
//  SignUpViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    var errorsInForm: Bool = false
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // MARK: Private methods
    private func resetErrors() {
        let textFields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField, genderTextField]
        let errorLabels = [nameErrorLabel, emailErrorLabel, passwordErrorLabel, confirmPasswordErrorLabel, genderErrorLabel]
        
        for i in 0..<textFields.count {
            textFields[i]?.layer.borderColor = UIColor.black.cgColor
            errorLabels[i]?.isHidden = true
        }
        
        errorsInForm = false
    }
    
    private func formDataIsValid() -> Bool {
        var result = true
        
        if nameIsInvalid() {
            result = false
            showErrorInForm(textField: nameTextField, errorLabel: nameErrorLabel)
        }
        
        if emailIsInvalid() {
            result = false
            showErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
        }
        
        if passwordIsInvalid() {
            result = false
            showErrorInForm(textField: passwordTextField, errorLabel: passwordErrorLabel)
        } else if confirmPasswordIsInvalid() {
            result = false
            showErrorInForm(textField: confirmPasswordTextField, errorLabel: confirmPasswordErrorLabel)
        }
        
        if genderIsInvalid() {
            result = false
            showErrorInForm(textField: genderTextField, errorLabel: genderErrorLabel)
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
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.instantiateViewController(HomeViewController.self, storyboardIdentifier: "Onboarding")
        }) { (error) in
            self.hideSpinner()
            self.showMessageError(title: "Error", errorMessage: error.domain.capitalizeFirstLetter())
        }
    }
    
    private func showErrorInForm(textField: UITextField, errorLabel: UILabel) {
        textField.addBorder(color: .tomato, weight: 1.0)
        errorLabel.isHidden = false
    }
    
    private func nameIsInvalid() -> Bool {
        let name = nameTextField.text!
        return name.isEmpty
    }

    private func emailIsInvalid() -> Bool {
        let email = emailTextField.text!
        return !email.isEmailFormatted()
    }
    
    private func passwordIsInvalid() -> Bool {
        let password = passwordTextField.text!
        return password.length() < minPasswordLength
    }
    
    private func confirmPasswordIsInvalid() -> Bool {
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        return confirmPassword != password
    }
    
    private func genderIsInvalid() -> Bool {
        let gender = genderTextField.text!
        return gender.isEmpty
    }
    
    // MARK: PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderValues.count
    }
    
    // MARK: PickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = genderValues[row]
    }
    
    // MARK: TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        genderPickerView.selectRow(0, inComponent: 0, animated: false)
        pickerView(genderPickerView, didSelectRow: 0, inComponent: 0)
    }
    
}
