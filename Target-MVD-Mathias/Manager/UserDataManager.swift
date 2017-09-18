//
//  UserDataManager.swift
//  swift-base
//
//  Created by TopTier labs on 15/2/16.
//  Copyright © 2016 TopTier labs. All rights reserved.
//

import UIKit
import CoreLocation

class UserDataManager: NSObject {
  
  class func storeUserObject(_ user: User) {
    let defaults = UserDefaults.standard
    defaults.set(NSKeyedArchiver.archivedData(withRootObject: user), forKey: "seatmate-user")
  }
  
  class func getUserObject() -> User? {
    let defaults = UserDefaults.standard
    
    if let data = defaults.object(forKey: "seatmate-user") as? Data {
      let unarc = NSKeyedUnarchiver(forReadingWith: data)
      return unarc.decodeObject(forKey: "root") as? User
    }
    
    return nil
  }
  
  class func deleteUserObject() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "seatmate-user")
  }
  
  class func checkSignin() -> Bool {
    return self.getUserObject() != nil
  }
  
  class func getUserId() -> Int {
    return self.getUserObject()?.id ?? 0
  }
  
  // MARK: Facebook
  
  class func setUserFromFacebook() {
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: "from-facebook")
  }
  
  class func isUserFromFacebook() -> Bool {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: "from-facebook") as? Bool ?? false
  }
  
  class func deleteUserFromFacebook() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "from-facebook")
  }
  
  // MARK: Access token functions
  
  class func storeAccessToken(_ token: String) {
    let defaults = UserDefaults.standard
    defaults.set(token, forKey: "access-token")
  }
  
  class func getAccessToken() -> String? {
    let defaults = UserDefaults.standard
    return defaults.object(forKey: "access-token") as? String
  }
  
  class func deleteAccessToken() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "access-token")
  }
  
  class func userHasToken() -> Bool {
    return self.getAccessToken() != nil
  }
  
  // MARK: User location
  
  class func storeLastLocation(_ coordinates: CLLocationCoordinate2D) {
    let defaults = UserDefaults.standard
    defaults.set(coordinates.latitude, forKey: "last-user-location-lat")
    defaults.set(coordinates.longitude, forKey: "last-user-location-lng")
  }
  
  class func getLastLocation() -> CLLocationCoordinate2D {
    let defaults = UserDefaults.standard
    let lat = defaults.double(forKey: "last-user-location-lat")
    let lng = defaults.double(forKey: "last-user-location-lng")
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
  }
}
