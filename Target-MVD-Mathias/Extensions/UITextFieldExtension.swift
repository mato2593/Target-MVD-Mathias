//
//  UITextFieldExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

extension UITextField {
  
  func addLeftPadding(_ padding: CGFloat = 10) {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
    leftView = paddingView
    leftViewMode = .always
  }
  
}
