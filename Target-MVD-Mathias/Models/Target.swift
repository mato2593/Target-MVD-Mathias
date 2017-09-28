//
//  Target.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Target: NSObject, NSCoding {
  
  var id: Int
  var radius: Int
  var lat: Double
  var lng: Double
  var title: String
  var topic: Topic
  var user: Int
  
  init(id: Int = 0, radius: Int, lat: Double, lng: Double, title: String, topic: Topic, user: Int) {
    self.id = id
    self.radius = radius
    self.lat = lat
    self.lng = lng
    self.title = title
    self.topic = topic
    self.user = user
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeInteger(forKey: "target-id")
    self.radius = aDecoder.decodeInteger(forKey: "target-radius")
    self.lat = aDecoder.decodeDouble(forKey: "target-lat")
    self.lng = aDecoder.decodeDouble(forKey: "target-lng")
    self.title = aDecoder.decodeObject(forKey: "target-title") as? String ?? ""
    self.topic = aDecoder.decodeObject(forKey: "target-topic") as? Topic ?? Topic()
    self.user = aDecoder.decodeInteger(forKey: "target-user")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "target-id")
    aCoder.encode(self.radius, forKey: "target-radius")
    aCoder.encode(self.lat, forKey: "target-lat")
    aCoder.encode(self.lng, forKey: "target-lng")
    aCoder.encode(self.title, forKey: "target-title")
    aCoder.encode(self.topic, forKey: "target-topic")
    aCoder.encode(self.user, forKey: "target-user")
  }
  
  // MARK: Parser
  class func parse(fromJSON json: JSON) -> Target {
    let topic = Topic.parse(fromJSON: json["topic"])
    
    return Target(id: json["id"].intValue,
                  radius: json["radius"].intValue,
                  lat: json["latitude"].doubleValue,
                  lng: json["longitude"].doubleValue,
                  title: json["title"].stringValue,
                  topic: topic,
                  user: json["user"].intValue)
  }
  
  class func parse(fromJSONArray jsonArray: [JSON]) -> [Target] {
    return jsonArray.map { parse(fromJSON: $0) }
  }
}
