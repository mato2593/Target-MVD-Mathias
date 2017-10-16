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
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    
    collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "OpenSans", size: 12.0)
    collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    inputToolbar.contentView.leftBarButtonItem = nil
    inputToolbar.contentView.rightBarButtonItem.setTitleColor(.black, for: .normal)
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
    let screenWidth = UIScreen.main.bounds.size.width
    
    let navigationBarSeparator = UIView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: 0.5))
    navigationBarSeparator.backgroundColor =  UIColor.black.withAlphaComponent(0.5)
    view.addSubview(navigationBarSeparator)
    
    let topicImageView = UIImageView(frame: CGRect(x: screenWidth - 32, y: 31, width: 22, height: 22))
    topicImageView.sd_setImage(with: match?.topic.icon)
    view.addSubview(topicImageView)
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
    
    cell?.textView?.textColor = UIColor.black
    return cell!
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
    return messages[indexPath.item]
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
    let message = messages[indexPath.item]
    
    return message.senderId == senderId ? outgoingBubbleImageView : incomingBubbleImageView
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
}
