//
//  NibView.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/6/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class NibView: UIView {
  
  var view: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // Setup view from .xib file
    xibSetup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    // Setup view from .xib file
    xibSetup()
  }
}

private extension NibView {
  
  func xibSetup() {
    backgroundColor = UIColor.clear
    view = loadViewFromNib()
    view.frame = bounds
    addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
  }
}
