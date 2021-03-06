//
//  UIViewControllerExtension.swift
//  swift-base
//
//  Created by ignacio chiazzo Cardarello on 10/20/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  //MARK: Message Error
  func showMessageError(title: String? = nil, errorMessage: String, actionTitle: String = "Ok", handler: ((_ action: UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
    alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: handler))
    present(alert, animated: true, completion: nil)
  }
  
  func showSpinner(message: String = "Please Wait", comment: String = "") {
    view.showSpinner(message: message, comment: comment)
  }
  
  func hideSpinner() {
    view.hideSpinner()
  }
  
  func makeNavigationBarTransparent(hidesBackButton: Bool = true) {
    navigationItem.setHidesBackButton(hidesBackButton, animated: false)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
  }
  
  func getViewControllerFromNavigationStack<T: UIViewController>(type: T.Type) -> T? {
    var viewController: T?
    
    if let viewControllers = navigationController?.viewControllers {
      for vc in viewControllers {
        if let vc = vc as? T {
          vc.removeFromParentViewController()
          viewController = vc
        }
      }
    }
    
    return viewController
  }
}
