//
//  GeneralHelper.swift
//  swift-base
//
//  Created by TopTier labs on 2/19/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class UIHelper {
  //MARK: Customize Views
  class func stylizePlaceholdersFor(_ targets: [UITextField], color: UIColor = UIColor.lightGray) {
    for textField in targets {
      textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSForegroundColorAttributeName: color])
    }
  }
    
  class func initSpinner(with frame: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80)) -> MBProgressHUD {
    let hud =  MBProgressHUD.init(frame: frame)
    hud.removeFromSuperViewOnHide = true
    hud.mode = .indeterminate
    hud.animationType = .zoom
    hud.isUserInteractionEnabled = false
    return hud
  }
  
  // MARK: Form errors
  class func toggleErrorInForm(error: Bool, textField: UITextField, errorLabel: UILabel, errorMessage: String = "") {
    if error {
      showErrorInForm(textField: textField, errorLabel: errorLabel, errorMessage: errorMessage)
    } else {
      hideErrorInForm(textField: textField, errorLabel: errorLabel)
    }
  }
  
  class func showErrorInForm(textField: UITextField, errorLabel: UILabel?, errorMessage: String = "") {
    textField.addBorder(color: .tomato, weight: 1.5)
    
    if !errorMessage.isEmpty {
      errorLabel?.text = errorMessage
    }
    
    errorLabel?.isHidden = false
  }
  
  class func hideErrorInForm(textField: UITextField, errorLabel: UILabel?) {
    textField.addBorder(color: .black, weight: 1)
    errorLabel?.isHidden = true
  }
}
