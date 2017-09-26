//
//  User.swift
//  swift-base
//
//  Created by TopTier labs on 1/18/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject, NSCoding {
  var id: Int
  var username: String
  var email: String
  var gender: String
  var image: URL?
  
  init(id: Int = 0, username: String = "", email: String = "", image: String = "", gender: String = "") {
    self.id = id
    self.username = username
    self.email = email
    self.image = URL(string: image)
    self.gender = gender
  }
  
  required init(coder aDecoder: NSCoder) {
    self.id = aDecoder.decodeInteger(forKey: "user-id")
    self.username = aDecoder.decodeObject(forKey: "user-username") as? String ?? ""
    self.email = aDecoder.decodeObject(forKey: "user-email") as? String ?? ""
    self.image = URL(string: aDecoder.decodeObject(forKey: "user-image") as? String ?? "")
    self.gender = aDecoder.decodeObject(forKey: "user-gender") as? String ?? ""
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(self.id, forKey: "user-id")
    aCoder.encode(self.username, forKey: "user-username")
    aCoder.encode(self.email, forKey: "user-email")
    aCoder.encode(self.image?.absoluteString, forKey: "user-image")
    aCoder.encode(self.gender, forKey: "user-gender")
  }
  
  //MARK Parser
  class func parse(fromJSON json: JSON) -> User {
    return User(id:       json["user_id"].intValue,
                username: json["name"].stringValue,
                email:    json["email"].stringValue,
                image:    json["image"].stringValue,
                gender:   json["gender"].stringValue
    )
  }
}
