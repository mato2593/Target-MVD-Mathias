//
//  MatchConversation.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON
import JSQMessagesViewController

class MatchConversation: NSObject {
  
  var id: Int
  var topic: Topic
  var user: User
  var title: String
  var channelId: String
  var unread: Int
  var lastMessage: JSQMessage?
  var active: Bool
  
  init(id: Int, topic: Topic, user: User, title: String = "", channelId: String = "", unread: Int = 0, lastMessage: JSQMessage? = nil, active: Bool = true) {
    self.id = id
    self.topic = topic
    self.user = user
    self.title = title
    self.channelId = channelId
    self.unread = unread
    self.lastMessage = lastMessage
    self.active = active
  }
  
  // MARK: Parser
  class func parse(fromJSON json: JSON) -> MatchConversation {
    let topic = Topic.parse(fromJSON: json["topic"])
    let user = User.parse(fromJSON: json["user"])
    let lastMessage = JSQMessage.parse(fromJSON: json["last_message"])
    
    return MatchConversation(id: json["match_id"].intValue,
                            topic: topic,
                            user: user,
                            title: json["title"].stringValue,
                            channelId: json["channel_id"].stringValue,
                            unread: json["unread"].intValue,
                            lastMessage: lastMessage,
                            active: json["active"].boolValue)
  }
  
  class func parse(fromJSONArray jsonArray: [JSON]) -> [MatchConversation] {
    return jsonArray.map { parse(fromJSON: $0) }
  }
  
  class func parse(fromPushNotification push: JSON) -> MatchConversation {
    let topic = Topic.parse(fromJSON: push["topic"])
    let user = User.parse(fromJSON: push["user"])
    
    return MatchConversation(id: push["id"].intValue,
                             topic: topic,
                             user: user,
                             title: push["title"].stringValue,
                             channelId: push["channel_id"].stringValue)
  }
}
