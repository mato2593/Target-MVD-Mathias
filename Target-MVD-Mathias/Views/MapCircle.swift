//
//  MapCircle.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/2/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import Foundation
import GoogleMaps

class MapCircle: GMSCircle {
  
  var timer: Timer?
  var radiusGoal: Double = 0
  var radiusVariation: Double = 0
  
  func hide() {
    radius = 0
    map = nil
    
    if let timer = timer {
      timer.invalidate()
    }
  }
  
  func show(inMap map: GMSMapView, radiusGoal: Double, position: CLLocationCoordinate2D) {
    radius = 0
    self.radiusGoal = radiusGoal
    self.map = map
    self.position = position
    radiusVariation = radiusGoal / 10
    
    let interval = 0.005
    timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animateShowing), userInfo: nil, repeats: true)
  }
  
  @objc private func animateShowing() {
    if radius < radiusGoal {
      radius += radiusVariation
    } else {
      timer!.invalidate()
    }
  }
  
}
