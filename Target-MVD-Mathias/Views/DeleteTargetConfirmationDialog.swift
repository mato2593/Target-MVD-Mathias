//
//  DeleteTargetConfirmationDialog.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 11/2/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

protocol DeleteTargetConfirmationDialogDelegate: class {
  func didTapDeleteTargetButton(target: Target)
}

class DeleteTargetConfirmationDialog: UIView, Modal {

  // MARK: Outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var dialogView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var targetTopicView: UIView!
  @IBOutlet weak var targetTopicImageView: UIImageView!
  @IBOutlet weak var targetTitleLabel: UILabel!
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  var target: Target?
  weak var delegate: DeleteTargetConfirmationDialogDelegate?
 
  // MARK: Initializers
  init(withTarget target: Target) {
    super.init(frame: UIScreen.main.bounds)
    loadView()
    
    self.target = target
    setupTopicView()
    setupLetterSpacing()
    targetTitleLabel.text = target.title
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadView()
  }
  
  // MARK: Functions
  @IBAction func didTapOnDeleteTargetButton(_ sender: Any) {
    dismiss(animated: true)
    delegate?.didTapDeleteTargetButton(target: target!)
  }
  
  @IBAction func didTapOnCancelButton(_ sender: Any) {
    dismiss(animated: true)
  }
  
  // MARK: Functions
  private func loadView() {
    Bundle.main.loadNibNamed("DeleteTargetConfirmationDialog", owner: self, options: nil)
    addSubview(contentView)
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private func setupTopicView() {
    targetTopicView.layer.cornerRadius = targetTopicView.frame.size.width / 2
    targetTopicView.layer.masksToBounds = true
    targetTopicImageView.sd_setImage(with: target?.topic.icon)
  }
  
  private func setupLetterSpacing() {
    titleLabel.setSpacing(ofCharacter: 2.0)
    targetTitleLabel.setSpacing(ofCharacter: 0.5)
    deleteButton.titleLabel?.setSpacing(ofCharacter: 1.6)
    cancelButton.titleLabel?.setSpacing(ofCharacter: 1.8)
  }
  
}
