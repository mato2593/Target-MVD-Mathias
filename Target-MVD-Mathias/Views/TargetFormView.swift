//
//  TargetFormView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

protocol TargetFormDelegate: class {
  func saveTarget(area: Int, title: String, topic: Topic)
  func editTarget(area: Int, title: String, topic: String)
  func deleteTarget()
  func cancelTargetCreation()
  func didTapOnSelectTopicField()
  func didChangeTargetArea(_ area: Int)
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

  @IBOutlet weak var selectTopicPlaceholderLabel: UILabel!
  @IBOutlet weak var topicStackView: UIStackView!
  @IBOutlet weak var topicImageView: UIImageView!
  @IBOutlet weak var topicLabel: UILabel!
  @IBOutlet weak var selectTopicButton: UIButton!
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var saveTargetButton: UIButton!
  
  // MARK: Variables
  var formType = TargetFormType.creation {
    didSet {
      setupLabelsAndButtons()
    }
  }
  weak var delegate: TargetFormDelegate?
  
  var firstTimeOpeningPicker = true
  var area = 50 {
    didSet {
      if formType == .edition {
        tryEnablingSaveTargetButton()
      }
    }
  }
  
  var title = "" {
    didSet {
      let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
      
      if trimmedTitle.isEmpty {
        disableSaveTargetButton()
      } else {
        tryEnablingSaveTargetButton()
      }
    }
  }
  
  var topic = Topic() {
    didSet {
      if topic.id > 0 {
        topicImageView.sd_setImage(with: topic.icon)
        selectTopicPlaceholderLabel.isHidden = true
        topicStackView.isHidden = false
        topicLabel.text = topic.label
        tryEnablingSaveTargetButton()
      } else {
        selectTopicPlaceholderLabel.isHidden = false
        topicStackView.isHidden = true
        disableSaveTargetButton()
      }
    }
  }
  
  var target: Target? = nil {
    didSet {
      if let target = target {
        for (index, area) in areas.enumerated() {
          if area.value == target.radius {
            areasPickerView.selectRow(index, inComponent: 0, animated: false)
            pickerView(areasPickerView, didSelectRow: index, inComponent: 0)
            break
          }
        }
        
        title = target.title
        titleTextField.text = target.title
        topic = target.topic
      }
    }
  }
  
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
  @IBAction func tapOnSelectTopicButton(_ sender: Any) {
    guard let delegate = delegate else {
      preconditionFailure("Delegate not set")
    }
    
    delegate.didTapOnSelectTopicField()
  }
  
  @IBAction func tapOnCancelTargetCreationButton(_ sender: Any) {
    guard let delegate = delegate else {
      preconditionFailure("Delegate not set")
    }
    
    switch formType {
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
    
    switch formType {
    case .creation:
      delegate.saveTarget(area: area, title: title, topic: topic)
    case .edition:
      delegate.editTarget(area: area, title: title, topic: topic.label)
    }
  }
  
  // MARK: Functions
  private func initView() {
    loadNib()
    setupTextFields()
    setupSelectTopicButton()
    setupLetterSpacing()
    setupLabelsAndButtons()
    disableSaveTargetButton()
  }
  
  private func loadNib() {
    Bundle.main.loadNibNamed("TargetFormView", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }
  
  private func setupTextFields() {
    let textFields: [UITextField] = [areaLengthTextField, titleTextField]
    UIHelper.stylizePlaceholdersFor(textFields, color: .black)
    
    areasPickerView.delegate = self
    areasPickerView.dataSource = self
    
    areaLengthTextField.inputView = areasPickerView
    
    areasPickerView.selectRow(0, inComponent: 0, animated: false)
    pickerView(areasPickerView, didSelectRow: 0, inComponent: 0)
    
    titleTextField.addLeftPadding()
  }
  
  private func setupSelectTopicButton() {
    selectTopicButton.addBorder(color: .black, weight: 1.0)
  }
  
  private func setupLetterSpacing() {
    cancelButton.titleLabel?.setSpacing(ofCharacter: 1.6)
    saveTargetButton.titleLabel?.setSpacing(ofCharacter: 1.6)
  }
  
  private func setupLabelsAndButtons() {
    var areaLengthTitle: String
    var topicTitle: String
    var cancelButtonTitle: String
    var saveButtonTitle: String
    
    switch formType {
    case .creation:
      areaLengthTitle = "SPECIFY AREA LENGTH"
      topicTitle = "SELECT A TOPIC"
      cancelButtonTitle = "CANCEL"
      saveButtonTitle = "SAVE TARGET"
    case .edition:
      areaLengthTitle = "AREA LENGTH"
      topicTitle = "TOPIC"
      cancelButtonTitle = "DELETE"
      saveButtonTitle = "SAVE"
    }
    
    areaLengthTitleLabel.text = areaLengthTitle
    topicTitleLabel.text = topicTitle
    cancelButton.setTitle(cancelButtonTitle, for: .normal)
    saveTargetButton.setTitle(saveButtonTitle, for: .normal)
  }
  
  func resetFields() {
    areasPickerView.selectRow(0, inComponent: 0, animated: false)
    pickerView(areasPickerView, didSelectRow: 0, inComponent: 0)
    
    titleTextField.text = ""
    title = ""
    topic = Topic()
    target = nil
  }
  
  func disableSaveTargetButton() {
    saveTargetButton.isEnabled = false
    saveTargetButton.layer.backgroundColor = UIColor.gray.cgColor
  }
  
  func tryEnablingSaveTargetButton() {
    let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
    
    if !trimmedTitle.isEmpty && topic.id > 0 && (formType == .creation || targetEdited()) {
      enableSaveTargetButton()
    } else {
      disableSaveTargetButton()
    }
  }
  
  func enableSaveTargetButton() {
    saveTargetButton.isEnabled = true
    saveTargetButton.layer.backgroundColor = UIColor.black.cgColor
  }
  
  private func targetEdited() -> Bool {
    var targetEdited = false
    
    if let target = target {
      targetEdited = target.title != title || target.radius != area || target.topic != topic
    }
    
    return targetEdited
  }
  
}

extension TargetFormView: UITextFieldDelegate {
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField == titleTextField {
      title = titleTextField.text ?? ""
    }
  }
  
}

extension TargetFormView: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return areas.count
  }
  
}

extension TargetFormView: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return areas[row].key
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    areaLengthTextField.text = areas[row].key
    area = areas[row].value
    
    if formType == .creation {
      delegate?.didChangeTargetArea(areas[row].value)
    }
  }
  
}
