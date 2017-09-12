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
  
  lazy var targetCircle: GMSCircle = {
    let targetCircle = GMSCircle()
    targetCircle.fillColor = .transparentWhite
    targetCircle.strokeColor = .macaroniAndCheese
    
    return targetCircle
  }()
  
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
  
  var topics: [Topic] = []
  var firstTimeUpdatingLocation = true
  
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
    addTargetCircle(radius: 50)
    
    targetFormView.resetFields()
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
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  private func setupTargetForm() {
    targetFormView.delegate = self
  }
  
  private func getTargetTopics() {
    TargetAPI.topics(success: { topics in
      self.topics = topics
      self.topicsTableView.reloadData()
    }) { error in
      print(error.domain)
    }
  }

  fileprivate func addTargetCircle(radius: Int) {
    let coordinates = mapView.camera.target
    
    targetCircle.position = coordinates
    targetCircle.radius = CLLocationDistance(radius)
    targetCircle.map = self.mapView
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    
    if let coordinates = location?.coordinate {
      userLocation = coordinates
      locationMarker.position = coordinates
      
      if firstTimeUpdatingLocation {
        firstTimeUpdatingLocation = false
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                              longitude: coordinates.longitude,
                                              zoom: 16.0)
        mapView.animate(to: camera)
      }
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
    targetCircle.map = nil
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
  
  func didChangeTargetArea(_ area: Int) {
    addTargetCircle(radius: area)
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
    let cell: TopicTableViewCell = {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "topicCell") as? TopicTableViewCell else {
        return TopicTableViewCell(style: .default, reuseIdentifier: "topicCell")
      }
      return cell
    }()
    
    let topic = topics[indexPath.row]
    
    cell.setup(withTopic: topic)
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    targetFormView.topic = topics[indexPath.row]
    tableView.deselectRow(at: indexPath, animated: false)
    
    UIView.transition(with: topicsTableView,
                      duration: 0.35,
                      animations: {
                        self.topicsTableView.center.y += self.topicsTableView.frame.size.height
    })
  }
  
}
