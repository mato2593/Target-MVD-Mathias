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
  func didTapOnSelectTopicField()
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
  var firstTimeOpeningPicker = true
  var topic = ""
  
  // MARK: Constants
  let areas: DictionaryLiteral = ["50 m": 50, "100 m": 100, "250 m": 250, "500 m": 500]
  let areasPickerView = UIPickerView()
  
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
    
    areasPickerView.delegate = self
    areasPickerView.dataSource = self
    
    areaLengthTextField.inputView = areasPickerView
    
    areasPickerView.selectRow(0, inComponent: 0, animated: false)
    pickerView(areasPickerView, didSelectRow: 0, inComponent: 0)
    
    topicTextField.delegate = self
    
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

extension TargetFormView: UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return areas.count
  }
  
}

extension TargetFormView: UIPickerViewDataSource {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return areas[row].key
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    areaLengthTextField.text = areas[row].key
  }
  
}

extension TargetFormView: UITextFieldDelegate {
  
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == topicTextField {
      guard let delegate = delegate else {
        preconditionFailure("Delegate not set")
      }
      
      delegate.didTapOnSelectTopicField()
      return false
    }
    
    return true
  }
  
}
