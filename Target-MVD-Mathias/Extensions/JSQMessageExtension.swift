//
//  JSQMessageExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/18/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import SwiftyJSON

extension JSQMessage {
  
  class func parse(fromJSON json: JSON) -> JSQMessage {
    let date = Date.parse(fromJSON: json["time"])
    
    return JSQMessage(senderId: String(describing: json["sender"].intValue),
                      senderDisplayName: "",
                      date: date,
                      text: json["text"].stringValue)
  }
  
  class func parse(fromJSONArray jsonArray: [JSON]) -> [JSQMessage] {
    return jsonArray.map { parse(fromJSON: $0) }
  }
}
