//
//  Match.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Match: NSObject, NSCoding {
  
  var id: Int
  var topic: Topic
  var user: User
  var title: String
  var channelId: String
  var unread: Int
  var lastMessages: [String]
  var active: Bool
  
  init(id: Int, topic: Topic, user: User, title: String = "", channelId: String = "", unread: Int, lastMessages: [String], active: Bool) {
    self.id = id
    self.topic = topic
    self.user = user
    self.title = title
    self.channelId = channelId
    self.unread = unread
    self.lastMessages = lastMessages
    self.active = active
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeInteger(forKey: "match-id")
    self.topic = aDecoder.decodeObject(forKey: "match-topic") as? Topic ?? Topic()
    self.user = aDecoder.decodeObject(forKey: "match-user") as? User ?? User()
    self.title = aDecoder.decodeObject(forKey: "match-title") as? String ?? ""
    self.channelId = aDecoder.decodeObject(forKey: "match-channel-id") as? String ?? ""
    self.unread = aDecoder.decodeInteger(forKey: "match-unread")
    self.lastMessages = aDecoder.decodeObject(forKey: "match-last-messages") as? [String] ?? []
    self.active = aDecoder.decodeBool(forKey: "match-active")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "match-id")
    aCoder.encode(self.topic, forKey: "match-topic")
    aCoder.encode(self.user, forKey: "match-user")
    aCoder.encode(self.title, forKey: "match-title")
    aCoder.encode(self.channelId, forKey: "match-channel-id")
    aCoder.encode(self.unread, forKey: "match-unread")
    aCoder.encode(self.lastMessages, forKey: "match-last-messages")
    aCoder.encode(self.active, forKey: "match-active")
  }
  
  // MARK: Parser
  class func parse(fromJSON json: JSON) -> Match {
    let topic = Topic.parse(fromJSON: json["topic"])
    let user = User.parse(fromJSON: json["user"])
    
    return Match(id: json["match_id"].intValue,
                 topic: topic,
                 user: user,
                 title: json["title"].stringValue,
                 channelId: json["channel_id"].stringValue,
                 unread: json["unread"].intValue,
                 lastMessages: json["last_message"].arrayValue.map { $0.stringValue },
                 active: json["active"].boolValue)
  }
  
  class func parse(fromJSONArray jsonArray: [JSON]) -> [Match] {
    var matches: [Match] = []
    
    for json in jsonArray {
      matches.append(parse(fromJSON: json))
    }
    
    return matches
  }
}
