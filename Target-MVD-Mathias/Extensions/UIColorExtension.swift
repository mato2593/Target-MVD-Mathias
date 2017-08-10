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
    
    class func createColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func tomato() -> UIColor {
        return UIColor.createColor(red: 224, green: 36, blue: 36)
    }
    
}
