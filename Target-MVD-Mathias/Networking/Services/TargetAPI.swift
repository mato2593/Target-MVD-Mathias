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
  
  fileprivate static let topicsUrl = "/topics/"
  fileprivate static let usersUrl = "/users/"
  fileprivate static let targetsUrl = "/targets/"
  
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
  
  class func createTarget(_ target: Target, success: @escaping (_ target: Target, _ matches: [MatchConversation]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + targetsUrl
    
    let params = [
      "target": [
        "lat": target.lat,
        "lng": target.lng,
        "title": target.title,
        "radius": target.radius,
        "topic_id": target.topic.id
      ]
    ]
    
    APIClient.sendPostRequest(url, params: params as [String : AnyObject], success: { (response) in
      let json = JSON(response)
      let target = Target.parse(fromJSON: json["target"])
      let matches = MatchConversation.parse(fromJSONArray: json["matches"].arrayValue)
      
      success(target, matches)
    }) { (error) in
      failure(error)
    }
  }
  
  class func targets(success: @escaping (_ response: [Target]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + targetsUrl
    
    APIClient.sendGetRequest(url, success: { (response) in
      let json = JSON(response)
      let targets = Target.parse(fromJSONArray: json["targets"].arrayValue)
      
      success(targets)
    }) { error in
      failure(error)
    }
  }
  
  class func updateTarget(target: Target, success: @escaping (_ target: Target, _ matches: [MatchConversation]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + targetsUrl + "\(target.id)"
    
    let params = [
      "lat": target.lat,
      "lng": target.lng,
      "title": target.title,
      "radius": target.radius,
      "topic_id": target.topic.id
    ] as [String : Any]
    
    APIClient.sendPutRequest(url, params: params as [String : AnyObject], success: { (response) in
      let json = JSON(response)
      let target = Target.parse(fromJSON: json["target"])
      let matches = MatchConversation.parse(fromJSONArray: json["matches"].arrayValue)
      
      success(target, matches)
    }) { (error) in
      failure(error)
    }
  }
  
  class func removeTarget(target: Target, success: @escaping (_ target: Target) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + targetsUrl + "\(target.id)"
    
    APIClient.sendDeleteRequest(url, success: { response in
      success(Target.parse(fromJSON: JSON(response)))
    }) { error in
      failure(error)
    }
  }
}
