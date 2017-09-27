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
  func setup(withMatch match: Match) {
    setupAvatarImageView(image: match.user.image)
    
    userNameLabel.text = match.user.username
    lastMessageLabel.text = match.lastMessages.last ?? "This conversation hasn't started yet"
    
    chatTopicImageView.sd_setImage(with: match.topic.icon)
    chatTopicImageView.alpha = match.unread > 0 ? 1 : 0.5
    
    setupUnreadMessagesView(withUnreadMessages: match.unread)
  }
  
  private func setupAvatarImageView(image: URL?) {
    userAvatarImageView.layer.cornerRadius = userAvatarImageView.frame.size.width/2
    userAvatarImageView.layer.masksToBounds = true
    userAvatarImageView.sd_setImage(with: image)
  }
  
  private func setupUnreadMessagesView(withUnreadMessages unread: Int) {
    unreadMessagesView.layer.cornerRadius = unreadMessagesView.frame.size.width/2
    unreadMessagesView.layer.masksToBounds = true
    unreadMessagesView.isHidden = unread < 1
    unreadMessagesLabel.text = "\(unread)"
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
}
