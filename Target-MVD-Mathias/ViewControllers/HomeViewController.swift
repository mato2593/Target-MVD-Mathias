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
  @IBOutlet weak var myLocationButton: UIButton!
  @IBOutlet weak var newTargetLocationImageView: UIImageView!
  
  // MARK: Variables
  var locationManager = CLLocationManager()
  var userLocation = CLLocationCoordinate2D()
  
  lazy var mapView: GMSMapView = {
    // Create a GMSCameraPosition that tells the map to display
    // coordinate 0,0, at zoom level 1.
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
    return GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
  }()
  
  lazy var locationMarker: GMSMarker = {
    let locationMarker = GMSMarker()
    locationMarker.icon = #imageLiteral(resourceName: "UserLocation")
    locationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    locationMarker.isFlat = true
    locationMarker.map = self.mapView
    return locationMarker
  }()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeNavigationBarTransparent()
    setLetterSpacing()
    setupMap()
  }
  
  // MARK: Actions
  @IBAction func tapOnMyLocationButton(_ sender: Any) {
    let camera = GMSCameraPosition.camera(withTarget: userLocation, zoom: 16.0)
    mapView.animate(to: camera)
  }
  
  @IBAction func tapOnCreateNewTargetButton(_ sender: Any) {
    let coordinates = mapView.camera.target
    // TODO: create a new Target with this coordinates
    print(coordinates)
  }
  
  // MARK: Functions
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    createNewTargetLabel.setSpacing(ofCharacter: defaultSpacing)
  }
  
  private func setupMap() {
    mapView.settings.compassButton = true
    mapViewContainer.addSubview(mapView)
    mapViewContainer.bringSubview(toFront: myLocationButton)
    mapViewContainer.bringSubview(toFront: newTargetLocationImageView)
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }

}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    
    if let coordinates = location?.coordinate {
      locationManager.stopUpdatingLocation()
      
      userLocation = coordinates
      
      let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                            longitude: coordinates.longitude,
                                            zoom: 16.0)
      
      locationMarker.position = coordinates
      
      mapView.animate(to: camera)
    }
  }
  
}
