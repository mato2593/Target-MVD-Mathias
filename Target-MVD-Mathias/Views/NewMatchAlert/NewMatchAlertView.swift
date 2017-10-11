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
  
  // MARK: Variables
  var match: Match? = nil {
    didSet {
      matchUserImageView.sd_setImage(with: match?.user.image)
      matchUserNameLabel.text = match?.user.username
    }
  }
  
  // MARK: Initializers
  init(withMatch match: Match) {
    super.init(frame: UIScreen.main.bounds)
    loadView()
    
    self.match = match
    setupAvatarImageView(image: match.user.image)
    matchUserNameLabel.text = match.user.username
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadView()
  }
  
  // MARK: Actions
  @IBAction func didTapStartChattingButton(_ sender: Any) {
    let chatViewController = UIStoryboard.instantiateViewController(ChatViewController.self)
    UIApplication.shared.keyWindow?.rootViewController?.present(chatViewController!, animated: true, completion: nil)
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
  
  private func setupAvatarImageView(image: URL?) {
    matchUserImageView.layer.cornerRadius = matchUserImageView.frame.size.width / 2
    matchUserImageView.layer.masksToBounds = true
    matchUserImageView.sd_setImage(with: image, placeholderImage: #imageLiteral(resourceName: "UserAvatarPlaceholder"))
  }
}
