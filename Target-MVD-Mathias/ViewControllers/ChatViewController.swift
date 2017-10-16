//
//  ChatViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
  
  // MARK: Variables
  var match: MatchConversation? {
    didSet {
      senderId = String(describing: match?.user.id)
      senderDisplayName = match?.user.username
      title = match?.user.username
    }
  }
  
  var messages: [JSQMessage] = []
  
  lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.macaroniAndCheese.withAlphaComponent(0.7))
  }()
  
  lazy var incomingBubbleImageView: JSQMessagesBubbleImage = {
    let bubbleImageFactory = JSQMessagesBubbleImageFactory()
    return bubbleImageFactory!.incomingMessagesBubbleImage(with: .white70)
  }()
  
  lazy var navigationBarSeparatorView: UIView = {
    let navigationBarSeparatorView = UIView()
    navigationBarSeparatorView.translatesAutoresizingMaskIntoConstraints = false
    navigationBarSeparatorView.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
    return navigationBarSeparatorView
  }()
  
  lazy var topicImageView: UIImageView = {
    let topicImageView = UIImageView()
    topicImageView.translatesAutoresizingMaskIntoConstraints = false
    topicImageView.sd_setImage(with: self.match?.topic.icon)
    return topicImageView
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    addMessage(withId: "test", name: "Test", text: "First message")
    addMessage(withId: senderId, name: "Me", text: "My first message")
    addMessage(withId: "test", name: "Test", text: "This is a very long message. This is a very long message. This is a very long message. This is a very long message.\nThis is a very long message.")
    addMessage(withId: senderId, name: "Me", text: "My reply")
    addMessage(withId: senderId, name: "Me", text: "To the long message")
    finishReceivingMessage()
  }
  
  // MARK: Private functions
  private func setupView() {
    view.addSubview(navigationBarSeparatorView)
    view.addSubview(topicImageView)
    
    setupChatView()
  }
  
  private func setupConstraints() {
    navigationBarSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    navigationBarSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    navigationBarSeparatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64.0).isActive = true
    navigationBarSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    
    topicImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0).isActive = true
    topicImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 31.0).isActive = true
    topicImageView.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
    topicImageView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
  }
  
  private func setupChatView() {
    collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "OpenSans", size: 12.0)
    collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    inputToolbar.contentView.leftBarButtonItem = nil
    inputToolbar.contentView.rightBarButtonItem.setTitleColor(.black, for: .normal)
  }
  
  private func addMessage(withId id: String, name: String, text: String) {
    if let message = JSQMessage(senderId: id, displayName: name, text: text) {
      messages.append(message)
    }
  }
}

extension ChatViewController {
 
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell
    let message = messages[indexPath.item]
    
    cell?.textView?.textColor = UIColor.black
    cell?.textView.backgroundColor = message.senderId == senderId ? UIColor.macaroniAndCheese.withAlphaComponent(0.7) : .white70
    cell?.textView.layer.cornerRadius = 8.0
    
    return cell!
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    return nil
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
}
