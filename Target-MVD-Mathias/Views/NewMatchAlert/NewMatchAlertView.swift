//
//  NewMatchAlertView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

protocol NewMatchAlertViewDelegate: class {
  func didTapStartChattingButton()
}

class NewMatchAlertView: UIView, Modal {

  // MARK: Outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet var backgroundView: UIView!
  @IBOutlet var dialogView: UIView!
  @IBOutlet weak var matchUserImageView: UIImageView!
  @IBOutlet weak var matchUserNameLabel: UILabel!
  
  // MARK: Variables
  var matches: [MatchConversation]?
  weak var delegate: NewMatchAlertViewDelegate?
  
  // MARK: Initializers
  init(withMatches matches: [MatchConversation]) {
    super.init(frame: UIScreen.main.bounds)
    loadView()
    
    self.matches = matches
    setupAvatarImageView(image: matches.first?.user.image)
    matchUserNameLabel.text = matches.first?.user.username
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadView()
  }
  
  // MARK: Actions
  @IBAction func didTapStartChattingButton(_ sender: Any) {
    dismiss(animated: true)
    delegate?.didTapStartChattingButton()
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
  
  private func setupAvatarImageView(image: URL?) {
    matchUserImageView.layer.cornerRadius = matchUserImageView.frame.size.width / 2
    matchUserImageView.layer.masksToBounds = true
    matchUserImageView.sd_setImage(with: image, placeholderImage: #imageLiteral(resourceName: "UserAvatarPlaceholder"))
  }
}
