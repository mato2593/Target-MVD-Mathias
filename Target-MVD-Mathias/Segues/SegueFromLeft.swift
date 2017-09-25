//
//  SegueFromLeft.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 8/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class SegueFromLeft: UIStoryboardSegue {
  
  override func perform() {
    source.navigationController!.setPushFromLeftTransition()
    source.navigationController!.pushViewController(destination, animated: false)
  }
  
}
