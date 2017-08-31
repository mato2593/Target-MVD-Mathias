//
//  HomeViewController.swift
//  swift-base
//
//  Created by TopTier labs on 5/23/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var mapViewContainer: UIView!
  @IBOutlet weak var createNewTargetLabel: UILabel!
  
  // MARK: Variables
  var locationManager = CLLocationManager()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeNavigationBarTransparent()
    setLetterSpacing()
    
    // Create a GMSCameraPosition that tells the map to display
    // coordinate -34.906334,-56.184856, at zoom level 16.
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 5.0)
    let mapView = GMSMapView.map(withFrame: mapViewContainer.bounds, camera: camera)
    mapView.settings.myLocationButton = true
    
    mapViewContainer.addSubview(mapView)
  }
  
  // MARK: Functions
  
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    createNewTargetLabel.setSpacing(ofCharacter: defaultSpacing)
  }
  
  @IBAction func tapOnGetMyProfile(_ sender: Any) {
    UserAPI.getMyProfile({ (json) in
      print(json)
    }) { (error) in
      print(error)
    }
  }

}
