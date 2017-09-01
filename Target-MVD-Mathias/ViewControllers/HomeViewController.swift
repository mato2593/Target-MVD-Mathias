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
  lazy var mapView: GMSMapView = {
    // Create a GMSCameraPosition that tells the map to display
    // coordinate -34.906334,-56.184856, at zoom level 16.
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
    return GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeNavigationBarTransparent()
    setLetterSpacing()
    setupMap()
  }
  
  // MARK: Functions
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    createNewTargetLabel.setSpacing(ofCharacter: defaultSpacing)
  }
  
  private func setupMap() {
    mapView.isMyLocationEnabled = true
    mapViewContainer.addSubview(mapView)
    
    locationManager.delegate = self
    locationManager.startUpdatingLocation()
  }

}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationManager.stopUpdatingLocation()
    
    let location = locations.last
    let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!,
                                          longitude: (location?.coordinate.longitude)!,
                                          zoom: 16.0)
    
    mapView.animate(to: camera)
    mapView.settings.myLocationButton = true
  }
  
}
