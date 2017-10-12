//
//  Match.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/9/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Match: NSObject {
  
  var id: Int
  var topic: Topic
  var user: User
  var title: String
  var channelId: String
  var unread: [String: JSON]
  var lastMessage: [String: JSON]
  
  init(id: Int, topic: Topic, user: User, title: String = "", channelId: String = "", unread: [String: JSON], lastMessage: [String: JSON]) {
    self.id = id
    self.topic = topic
    self.user = user
    self.title = title
    self.channelId = channelId
    self.unread = unread
    self.lastMessage = lastMessage
  }
  
  // MARK: Parser
  class func parse(fromJSON json: JSON) -> Match {
    let topic = Topic.parse(fromJSON: json["topic"])
    let user = User.parse(fromJSON: json["user"])
    
    return Match(id: json["id"].intValue,
                 topic: topic,
                 user: user,
                 title: json["title"].stringValue,
                 channelId: json["channel_id"].stringValue,
                 unread: json["unread"].dictionaryValue,
                 lastMessage: json["last_message"].dictionaryValue)
  }
}
