//
//  UILabelExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/16/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
  
  func setSpacing(ofLine lineSpacing: CGFloat? = nil, ofCharacter character: CGFloat) {
    if let mutableAttributes = attributedText?.mutableCopy() as? NSMutableAttributedString, let text = text {
  
      if let lineSpacing = lineSpacing {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        mutableAttributes.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text.length()))
      }
      
      mutableAttributes.addAttribute(NSKernAttributeName, value: character, range: NSRange(location: 0, length: text.length()))
      attributedText = mutableAttributes
    }
  }
  
}
