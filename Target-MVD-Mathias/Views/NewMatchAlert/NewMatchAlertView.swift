//
//  NewMatchAlertView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class NewMatchAlertView: NibView, Modal {

  // MARK: Outlets
  @IBOutlet var backgroundView: UIView!
  @IBOutlet var dialogView: UIView!
  @IBOutlet weak var matchUserImageView: UIImageView!
  @IBOutlet weak var matchUserNameLabel: UILabel!
  
  // MARK: Actions
  @IBAction func didTapStartChattingButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func didTapSkipButton(_ sender: Any) {
    dismiss(animated: true)
  }
}
