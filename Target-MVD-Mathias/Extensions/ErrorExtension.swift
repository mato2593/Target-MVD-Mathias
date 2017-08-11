//
//  ErrorExtension.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/11/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation

extension Error {
    var code: Int {
        return _code
    }
    
    var domain: String {
        return _domain
    }
}
