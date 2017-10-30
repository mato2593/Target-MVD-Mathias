//
//  ChatViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import PusherSwift
import SwiftyJSON

class ChatViewController: JSQMessagesViewController {
  
  // MARK: Variables
  var match: MatchConversation?
  
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
  
  var pusher: Pusher?
  var channel: PusherChannel?
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    senderId = "\(UserDataManager.getUserId())"
    senderDisplayName = "\(UserDataManager.getUserObject()?.username ?? "")"
    
    registerCells()
    setupView()
    setupConstraints()
    fetchMessages()
    registerForMessages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.backgroundColor = .white
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    MatchesAPI.closeConversation(withMatch: match?.id ?? 0, success: {}, failure: { _ in })
  }
  
  // MARK: Private functions
  private func registerCells() {
    incomingCellIdentifier = IncomingMessagesCollectionViewCell.cellReuseIdentifier()
    incomingMediaCellIdentifier = IncomingMessagesCollectionViewCell.mediaCellReuseIdentifier()
    outgoingCellIdentifier = OutgoingMessagesCollectionViewCell.cellReuseIdentifier()
    outgoingMediaCellIdentifier = OutgoingMessagesCollectionViewCell.mediaCellReuseIdentifier()
    
    collectionView.register(IncomingMessagesCollectionViewCell.nib(), forCellWithReuseIdentifier: incomingCellIdentifier)
    collectionView.register(IncomingMessagesCollectionViewCell.nib(), forCellWithReuseIdentifier: incomingMediaCellIdentifier)
    collectionView.register(OutgoingMessagesCollectionViewCell.nib(), forCellWithReuseIdentifier: outgoingCellIdentifier)
    collectionView.register(OutgoingMessagesCollectionViewCell.nib(), forCellWithReuseIdentifier: outgoingMediaCellIdentifier)
  }
  
  private func setupView() {
    view.addSubview(navigationBarSeparatorView)
    
    setupNavigationBar()
    setupChatView()
  }
  
  private func setupConstraints() {
    navigationBarSeparatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    navigationBarSeparatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    navigationBarSeparatorView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64.0).isActive = true
    navigationBarSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
  }
  
  private func setupNavigationBar() {
    let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
    statusBarView.backgroundColor = .white
    view.addSubview(statusBarView)
    
    let topicImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
    topicImageView.sd_setImage(with: self.match?.topic.icon)
    navigationItem.setRightBarButton(UIBarButtonItem(customView: topicImageView), animated: true)
    
    setupTitleView()
  }
  
  private func setupTitleView() {
    let username = match?.user.username
    let matchTitle = match?.title
    
    let titleParameters = [
      NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: UIFontWeightSemibold)
    ] as [String: Any]
    
    let subtitleParameters = [
      NSForegroundColorAttributeName: UIColor.grayLight,
      NSFontAttributeName: UIFont(name: "OpenSans-Semibold", size: 11) ?? UIFont.systemFont(ofSize: 11, weight: UIFontWeightSemibold)
    ] as [String : Any]
    
    let titleText = NSMutableAttributedString(string: username!, attributes: titleParameters)
    
    titleText.append(NSAttributedString(string: "\n"))
    titleText.append(NSAttributedString(string: matchTitle!, attributes: subtitleParameters))
    
    let size = titleText.size()
    
    guard let height = navigationController?.navigationBar.frame.size.height else {
      title = match?.user.username
      return
    }
    
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: height))
    titleLabel.attributedText = titleText
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    
    navigationItem.titleView = titleLabel
  }
  
  private func setupChatView() {
    collectionView.collectionViewLayout.messageBubbleFont = UIFont(name: "OpenSans", size: 12.0)
    collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
    collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    inputToolbar.contentView.leftBarButtonItem = nil
    inputToolbar.contentView.rightBarButtonItem.setTitleColor(.black, for: .normal)
  }
  
  // MARK: Message related
  private func fetchMessages() {
    MatchesAPI.messages(forMatch: match?.id ?? 0, success: { messages in
      self.messages = messages
      self.finishReceivingMessage()
    }, failure: { error in
      self.showMessageError(errorMessage: error.domain)
    })
  }
  
  private func registerForMessages() {
    guard let pusherKey = ConfigurationManager.getValue(for: "PusherKey"), let match = match else {
      return
    }
    
    let options = PusherClientOptions(host: .cluster("us2"))
    pusher = Pusher(key: pusherKey, options: options)
    
    // subscribe to channel and bind to event
    channel = pusher?.subscribe(match.channelId)
    
    _ = channel?.bind(eventName: "new_message", callback: { (data: Any?) -> Void in
      if let data = data as? [String : AnyObject] {
        if data["text"] != nil {
          self.messages.append(JSQMessage.parse(fromJSON: JSON(data)))
          self.finishReceivingMessage()
        }
      }
    })
    
    pusher?.connect()
  }
  
  override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    MatchesAPI.sendMessage(toMatch: match?.id ?? 0, messageText: text, success: { message in
      self.messages.append(message)
      self.finishSendingMessage()
    }, failure: { error in
      self.showMessageError(errorMessage: error.domain)
    })
  }
  
  func newMessageReceived(_ message: JSQMessage) {
    messages.append(message)
    finishReceivingMessage()
  }
}

extension ChatViewController {
 
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as? MessagesCollectionViewCell
    let message = messages[indexPath.item]
    
    cell?.textView.textColor = UIColor.black
    cell?.textView.backgroundColor = message.senderId == senderId ? UIColor.macaroniAndCheese.withAlphaComponent(0.7) : .white70
    cell?.textView.layer.cornerRadius = 8.0
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    
    cell?.messageTimestampLabel.text = formatter.string(from: message.date)
    
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
