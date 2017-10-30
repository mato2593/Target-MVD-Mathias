//
//  DateExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/19/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Date {
  
  static func parse(fromJSON json: JSON) -> Date {
    let date = json["date"]
    
    var dateComponents = DateComponents()
    dateComponents.year = date["year"].intValue
    dateComponents.month = date["month"].intValue
    dateComponents.day = date["day"].intValue
    dateComponents.hour = json["hour"].intValue
    dateComponents.minute = json["min"].intValue
    dateComponents.second = json["sec"].intValue
    
    return Calendar.current.date(from: dateComponents)!
  }
}
