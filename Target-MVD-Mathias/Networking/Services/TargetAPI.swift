//
//  TargetsAPI.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/7/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class TargetAPI {
  
  fileprivate static let topicsUrl = "/topics"
  
  class func topics(success: @escaping (_ response: [Topic]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    APIClient.sendGetRequest(topicsUrl, success: { (response) in
      let json = JSON(response)
      let topicsArray = json["topics"].arrayValue
      
      var topics: [Topic] = []
      
      for topic in topicsArray {
        topics.append(Topic.parse(fromJSON: topic))
      }
      
      success(topics)
    }) { (error) in
      failure(error)
    }
  }
  
}
