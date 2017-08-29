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
  
  // Change Password Dialog
  @IBOutlet weak var changePasswordView: UIView!
  
  @IBOutlet weak var currentPasswordLabel: UILabel!
  @IBOutlet weak var newPasswordLabel: UILabel!
  @IBOutlet weak var reenterNewPasswordLabel: UILabel!
  
  @IBOutlet weak var currentPasswordTextField: UITextField!
  @IBOutlet weak var newPasswordTextField: UITextField!
  @IBOutlet weak var reenterNewPasswordTextField: UITextField!
  
  @IBOutlet weak var doneChangingPasswordButton: UIButton!
  
  // MARK: Constants
  let imagePicker = UIImagePickerController()
  
  // MARK: Variables
  var imageChanged = false
  var usernameChanged = false
  var emailChanged = false
  var passwordChanged = false
  
  var username = ""
  var email = ""
  
  lazy var goBackToHomeNavigationItem: UIBarButtonItem = {
    return UIBarButtonItem(image: #imageLiteral(resourceName: "ForwardArrow"), style: .plain, target: self, action:#selector(UserProfileViewController.goBackToHome))
  }()
  
  var showingChangePasswordDialog = false {
    didSet {
      UIView.transition(with: changePasswordView,
                        duration: 0.35,
                        options: .transitionCrossDissolve,
                        animations: {
                          self.changePasswordView.isHidden = !self.showingChangePasswordDialog
                        },
                        completion: nil)
      
      goBackToHomeNavigationItem.isEnabled = !showingChangePasswordDialog
    }
  }
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupNavigationBar()
    
    setupView()
    
    setLetterSpacing()
    
    getUserData()
  }
  
  // MARK: Actions
  @IBAction func tapOnAvatarImageView(_ sender: Any) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    
    present(imagePicker, animated: true, completion: nil)
  }
  
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
      name: usernameChanged ? usernameTextField.text : nil,
      email: emailChanged ? emailTextField.text : nil,
      password: passwordChanged ? passwordTextField.text : nil,
      avatar64: imageChanged ? avatarImageView.image : nil,
      success: {
        self.resetInitialValues()
        self.hideSpinner()
        self.disableSaveChangesButton()
      }) { (error) in
        self.showMessageError(title: "Error", errorMessage: error.domain)
      }
  }
  
  @IBAction func tapOnDoneChangingPasswordButton(_ sender: Any) {
  }
  
  @IBAction func tapOutsideChangePasswordDialog(_ sender: Any) {
    showingChangePasswordDialog = false
  }
  
  // MARK: Functions
  func setupNavigationBar() {
    goBackToHomeNavigationItem.tintColor = .black
    
    navigationItem.setRightBarButton(goBackToHomeNavigationItem, animated: false)
    
    makeNavigationBarTransparent()
  }
  
  func setupView() {
    avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
    avatarImageView.layer.masksToBounds = true
    avatarImageView.addBorder(color: .black, weight: 3.0)
    imagePicker.delegate = self
    
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "********", attributes: [NSForegroundColorAttributeName: UIColor.black])
    
    disableSaveChangesButton()
  }
  
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    currentPasswordLabel.setSpacing(ofLine: 1.6, ofCharacter: defaultSpacing)
    newPasswordLabel.setSpacing(ofCharacter: defaultSpacing)
    reenterNewPasswordLabel.setSpacing(ofCharacter: defaultSpacing)
    doneChangingPasswordButton.titleLabel?.setSpacing(ofCharacter: defaultSpacing)
  }
  
  func getUserData() {
    let user = UserDataManager.getUserObject()
    
    usernameTextField.text = user?.username
    emailTextField.text = user?.email
    SDImageCache.shared().removeImage(forKey: user?.image?.absoluteString, withCompletion: {
      self.avatarImageView.sd_setImage(with: user?.image, placeholderImage: #imageLiteral(resourceName: "UserAvatarPlaceholder"), options: .refreshCached)
    })
    
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
  
  func resetInitialValues() {
    username = usernameTextField.text!
    email = emailTextField.text!
    imageChanged = false
  }
  
  func goBackToHome() {
    let homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
  
  func areTextFieldsValid(_ textFields: [UITextField]) -> Bool {
    var areValid = false
    
    do {
      for textField in textFields {
        try checkForErrors(textField: textField)
      }
      
      areValid = true
      hideErrorsInForm()
    } catch UserDataErrors.emptyUsername {
      UIHelper.showErrorInForm(textField: usernameTextField, errorLabel: usernameErrorLabel)
    } catch UserDataErrors.invalidEmail {
      UIHelper.showErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
    } catch {
      print("Something went wrong")
    }
    
    return areValid
  }
  
  func hideErrorsInForm() {
    UIHelper.hideErrorInForm(textField: usernameTextField, errorLabel: usernameErrorLabel)
    UIHelper.hideErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
  }
}

extension UserProfileViewController: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == passwordTextField {
      showingChangePasswordDialog = true
      
      return false
    }
    
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    switch textField {
    case usernameTextField:
      usernameChanged = usernameTextField.text != username
      validateTextField(usernameTextField)
    case emailTextField:
      emailChanged = emailTextField.text != email
      validateTextField(emailTextField)
    default:
      break
    }
    
    let errorsInForm = !(usernameTextField.text!.isValidUsername()) || !(emailTextField.text!.isEmailFormatted())
    let dataChanged = usernameChanged || emailChanged || imageChanged
    dataChanged && !errorsInForm ? enableSaveChangesButton() : disableSaveChangesButton()
  }
  
  func validateTextField(_ textField: UITextField) {
    do {
      try checkForErrors(textField: textField)
      let errorLabel = errorLabelFromTextField(textField)
      UIHelper.hideErrorInForm(textField: textField, errorLabel: errorLabel)
    } catch UserDataErrors.emptyUsername {
      UIHelper.showErrorInForm(textField: usernameTextField, errorLabel: usernameErrorLabel)
    } catch UserDataErrors.invalidEmail {
      UIHelper.showErrorInForm(textField: emailTextField, errorLabel: emailErrorLabel)
    } catch {
      print("Something went wrong")
    }
  }
  
  func checkForErrors(textField: UITextField) throws {
    switch textField {
    case usernameTextField:
      if !(usernameTextField.text!.isValidUsername()) {
        throw UserDataErrors.emptyUsername
      }
    case emailTextField:
      if !(emailTextField.text!.isEmailFormatted()) {
        throw UserDataErrors.invalidEmail
      }
    default:
      break
    }
  }
  
  func errorLabelFromTextField(_ textField: UITextField) -> UILabel? {
    var errorLabel: UILabel?
    
    switch textField {
    case usernameTextField:
      errorLabel = usernameErrorLabel
    case emailTextField:
      errorLabel = emailErrorLabel
    default:
      break
    }
    
    return errorLabel
  }
  
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      avatarImageView.contentMode = .scaleAspectFill
      avatarImageView.image = pickedImage
      imageChanged = true
      let formDataIsValid = usernameTextField.text!.isValidUsername() && emailTextField.text!.isEmailFormatted()
      formDataIsValid ? enableSaveChangesButton() : disableSaveChangesButton()
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
}
