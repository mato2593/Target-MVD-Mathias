//
//  Topic.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/7/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Topic: NSObject, NSCoding {
  
  var id: Int
  var label: String
  var icon: URL?
  
  init(id: Int = 0, label: String = "", icon: String = "") {
    self.id = id
    self.label = label
    self.icon = URL(string: icon)
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeInteger(forKey: "topic-id")
    self.label = aDecoder.decodeObject(forKey: "topic-label") as? String ?? ""
    self.icon = URL(string: aDecoder.decodeObject(forKey: "topic-icon") as? String ?? "")
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "topic-id")
    aCoder.encode(self.label, forKey: "topic-label")
    aCoder.encode(self.icon?.absoluteString, forKey: "topic-icon")
  }
  
  // MARK: Parser
  class func parse(fromJSON json: JSON) -> Topic {
    let id = json["topics_id"].int ?? json["id"].intValue
    
    return Topic(id:    id,
                 label: json["label"].stringValue,
                 icon:  json["icon"].stringValue
    )
  }
  
}
