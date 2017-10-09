//
//  NewMatchAlertView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class NewMatchAlertView: UIView, Modal {

  // MARK: Outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet var dialogView: UIView!
  @IBOutlet weak var matchUserImageView: UIImageView!
  @IBOutlet weak var matchUserNameLabel: UILabel!
  
  // MARK: Initializers
  init() {
    super.init(frame: UIScreen.main.bounds)
    loadView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: Actions
  @IBAction func didTapStartChattingButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  @IBAction func didTapSkipButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  // MARK: Functions
  func loadView() {
    Bundle.main.loadNibNamed("NewMatchAlertView", owner: self, options: nil)
    addSubview(contentView)
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
}
