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
  
  @IBOutlet weak var targetFormView: TargetFormView!
  @IBOutlet weak var topicsTableView: UITableView!
  
  // MARK: Variables
  var locationManager = CLLocationManager()
  var userLocation = CLLocationCoordinate2D()
  
  lazy var mapView: GMSMapView = {
    // Create a GMSCameraPosition that tells the map to display
    // coordinate -34.906334,-56.184856, at zoom level 16.
    let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 1.0)
    return GMSMapView.map(withFrame: self.mapViewContainer.bounds, camera: camera)
  }()
  
  var topics: [Topic] = []
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeNavigationBarTransparent()
    setLetterSpacing()
    setupMap()
    setupTargetForm()
    getTargetTopics()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    targetFormView.center.y += self.targetFormView.frame.size.height
    targetFormView.isHidden = false
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
    
    targetFormView.targetFormType = .creation
    UIView.transition(with: targetFormView,
                      duration: 0.35,
                      animations: {
                        self.targetFormView.center.y -= self.targetFormView.frame.size.height
                      })
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
    locationManager.startUpdatingLocation()
  }
  
  private func setupTargetForm() {
    targetFormView.delegate = self
    topicsTableView.delegate = self
  }
  
  private func getTargetTopics() {
    TargetAPI.topics(success: { topics in
      self.topics = topics
      self.topicsTableView.reloadData()
    }) { error in
      print(error.domain)
    }
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
      
      let locationMarker = GMSMarker(position: coordinates)
      locationMarker.icon = #imageLiteral(resourceName: "UserLocation")
      locationMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
      locationMarker.isFlat = true
      locationMarker.opacity = 0.67
      locationMarker.map = mapView
      
      mapView.animate(to: camera)
    }
  }
  
}

extension HomeViewController: TargetFormDelegate {
  
  func saveTarget(area: Int, title: String, topic: String) {
    UIView.transition(with: targetFormView,
                      duration: 0.35,
                      animations: {
                        self.targetFormView.center.y += self.targetFormView.frame.size.height
    })
  }
  
  func editTarget(area: Int, title: String, topic: String) {
    UIView.transition(with: targetFormView,
                      duration: 0.35,
                      animations: {
                        self.targetFormView.center.y += self.targetFormView.frame.size.height
    })
  }
  
  func cancelTargetCreation() {
    UIView.transition(with: targetFormView,
                      duration: 0.35,
                      animations: {
                        self.targetFormView.center.y += self.targetFormView.frame.size.height
    })
  }
  
  func deleteTarget() {
    UIView.transition(with: targetFormView,
                      duration: 0.35,
                      animations: {
                        self.targetFormView.center.y += self.targetFormView.frame.size.height
    })
  }
  
  func didTapOnSelectTopicField() {
    UIView.transition(with: topicsTableView,
                      duration: 0.35,
                      animations: {
                        self.topicsTableView.center.y -= self.topicsTableView.frame.size.height
    })
  }
  
}

extension HomeViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return topics.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell = {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
        return UITableViewCell(style: .default, reuseIdentifier: "cell")
      }
      return cell
    }()
    
    cell.textLabel?.text = topics[indexPath.row].label
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    targetFormView.topic = topics[indexPath.row].label
    print(topics[indexPath.row].label)
    tableView.deselectRow(at: indexPath, animated: false)
    
    UIView.transition(with: topicsTableView,
                      duration: 0.35,
                      animations: {
                        self.topicsTableView.center.y += self.topicsTableView.frame.size.height
    })
  }
  
}
