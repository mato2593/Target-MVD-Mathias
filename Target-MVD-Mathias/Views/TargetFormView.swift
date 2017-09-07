//
//  TargetFormView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

protocol TargetFormDelegate: class {
  func saveTarget(area: Int, title: String, topic: String)
  func editTarget(area: Int, title: String, topic: String)
  func deleteTarget()
  func cancelTargetCreation()
}

enum TargetFormType: String {
  case creation
  case edition
}

class TargetFormView: UIView {
  
  // MARK: Outlets
  @IBOutlet var contentView: UIView!
  
  @IBOutlet weak var areaLengthTitleLabel: UILabel!
  @IBOutlet weak var topicTitleLabel: UILabel!
  
  @IBOutlet weak var areaLengthTextField: UITextField!
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var topicTextField: UITextField!

  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var saveTargetButton: UIButton!
  
  // MARK: Variables
  var targetFormType = TargetFormType.creation
  weak var delegate: TargetFormDelegate?
  
  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initView()
  }
  
  // MARK: Actions
  @IBAction func tapOnCancelTargetCreationButton(_ sender: Any) {
    guard let delegate = delegate else {
      preconditionFailure("Delegate not set")
    }
    
    switch targetFormType {
    case .creation:
      delegate.cancelTargetCreation()
    case .edition:
      delegate.deleteTarget()
    }
  }
  
  @IBAction func tapOnSaveTargetButton(_ sender: Any) {
    guard let delegate = delegate else {
      preconditionFailure("Delegate not set")
    }
    
    let title = titleTextField.text ?? ""
    let topic = topicTextField.text ?? ""
    
    switch targetFormType {
    case .creation:
      delegate.saveTarget(area: 0, title: title, topic: topic)
    case .edition:
      delegate.editTarget(area: 0, title: title, topic: topic)
    }
  }
  
  // MARK: Functions
  private func initView() {
    loadNib()
    setupTextFields()
    setupLetterSpacing()
    setupLabels()
  }
  
  private func loadNib() {
    Bundle.main.loadNibNamed("TargetFormView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private func setupTextFields() {
    let textFields: [UITextField] = [areaLengthTextField, titleTextField, topicTextField]
    UIHelper.stylizePlaceholdersFor(textFields, color: .black)
    titleTextField.addLeftPadding()
  }
  
  private func setupLetterSpacing() {
    cancelButton.titleLabel?.setSpacing(ofCharacter: 1.6)
    saveTargetButton.titleLabel?.setSpacing(ofCharacter: 1.6)
  }
  
  private func setupLabels() {
    var areaLengthTitle: String
    var topicTitle: String
    
    switch targetFormType {
    case .creation:
      areaLengthTitle = "SPECIFY AREA LENGTH"
      topicTitle = "SELECT A TOPIC"
    case .edition:
      areaLengthTitle = "AREA LENGTH"
      topicTitle = "TOPIC"
    }
    
    areaLengthTitleLabel.text = areaLengthTitle
    topicTitleLabel.text = topicTitle
  }
  
}
