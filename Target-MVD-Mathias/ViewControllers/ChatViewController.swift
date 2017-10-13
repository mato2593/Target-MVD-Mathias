//
//  ChatViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  // MARK: Actions
  @IBAction func didTapOnBackNavigationItem(_ sender: Any) {
    if navigationController != nil {
      navigationController?.popViewController(animated: true)
    } else {
      dismiss(animated: true, completion: nil)
    }
  }
}
