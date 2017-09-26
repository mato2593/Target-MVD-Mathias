//
//  MatchesAPI.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/26/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MatchesAPI {
  
  fileprivate static let usersUrl = "/users/"
  fileprivate static let matchesUrl = "/match_conversations/"
  
  class func matches(success: @escaping (_ response: [Match]) -> Void, failure: @escaping (_ error: Error) -> Void) {
    let url = usersUrl + "\(UserDataManager.getUserId())" + matchesUrl
    
    APIClient.sendGetRequest(url, success: { response in
      let json = JSON(response)
      let matches = Match.parse(fromJSONArray: json["matches"].arrayValue)
      
      success(matches)
    }) { error in
      failure(error)
    }
  }
  
}
