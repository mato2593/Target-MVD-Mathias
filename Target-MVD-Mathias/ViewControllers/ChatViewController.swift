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
    
    // Do any additional setup after loading the view.
  }
  
  // MARK: Actions
  @IBAction func didTapOnBackNavigationItem(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}
