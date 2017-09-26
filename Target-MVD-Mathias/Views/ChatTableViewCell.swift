//
//  ChatTableViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
  
  // MARK: Outlets
  @IBOutlet weak var userAvatarImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var lastMessageLabel: UILabel!
  @IBOutlet weak var chatTopicImageView: UIImageView!
  @IBOutlet weak var unreadMessagesView: UIView!
  @IBOutlet weak var unreadMessagesLabel: UILabel!
  
  // MARK: Setup
  func setupView() {
    userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
    userAvatarImageView.layer.masksToBounds = true
    
    unreadMessagesView.layer.cornerRadius = unreadMessagesView.frame.size.width/2
    unreadMessagesView.layer.masksToBounds = true
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
