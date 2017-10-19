//
//  MatchesAPI.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON
import JSQMessagesViewController

class MatchesAPI {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let matchesUrl = "/match_conversations/"
  fileprivate static let messages = "/messages/"
  
  class func matches(success: @escaping (_ response: [MatchConversation]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + matchesUrl
    
    APIClient.sendGetRequest(url, success: { response in
      let json = JSON(response)
      let matches = MatchConversation.parse(fromJSONArray: json["matches"].arrayValue)
      
      success(matches)
    }, failure: { error in
      failure(error)
    })
  }
  
  class func messages(forMatch match: Int, success: @escaping (_ messages: [JSQMessage]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + matchesUrl + "\(match)" + messages
    
    APIClient.sendGetRequest(url, success: { response in
      let json = JSON(response)
      success(JSQMessage.parse(fromJSONArray: json["messages"].arrayValue).reversed())
    }, failure: { error in
      failure(error)
    })
  }
  
  class func sendMessage(toMatch match: Int, messageText: String, success: @escaping (_ message: JSQMessage) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + matchesUrl + "\(match)" + messages
    
    let params = [
      "message": [
        "text": messageText
      ]
    ] as [String: AnyObject]
    
    APIClient.sendPostRequest(url, params: params, success: { response in
      let json = JSON(response)
      success(JSQMessage.parse(fromJSON: json))
    }, failure: { error in
      failure(error)
    })
  }
  
  class func closeConversation(withMatch match: Int, success: @escaping () -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + matchesUrl + "\(match)/close"
    
    APIClient.sendPostRequest(url, params: nil, success: { _ in
      success()
    }, failure: { error in
      failure(error)
    })
  }
}
