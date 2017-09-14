//
//  UIColorExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/10/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
    self.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
  }
  
  static let tomato = UIColor(r: 224, g: 36, b: 36)
  static let macaroniAndCheese = UIColor(r: 239, g: 198, b: 56)
  static let transparentWhite = UIColor(r: 255, g: 255, b: 255, alpha: 0.7)
  
}
