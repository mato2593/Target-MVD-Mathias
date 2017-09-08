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
  
  var area: Int
  var title: String
  var topic: Topic
  
  init(area: Int, title: String, topic: Topic) {
    self.area = area
    self.title = title
    self.topic = topic
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.area = aDecoder.decodeInteger(forKey: "target-area")
    self.title = aDecoder.decodeObject(forKey: "target-title") as? String ?? ""
    self.topic = aDecoder.decodeObject(forKey: "target-topic") as? Topic ?? Topic()
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.area, forKey: "target-area")
    aCoder.encode(self.title, forKey: "target-title")
    aCoder.encode(self.topic, forKey: "target-topic")
  }
  
}
