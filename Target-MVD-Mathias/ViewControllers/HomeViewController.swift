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
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var createNewTargetLabel: UILabel!
  @IBOutlet weak var newTargetLocationImageView: UIImageView!
  
  @IBOutlet weak var targetFormView: TargetFormView!
  @IBOutlet weak var topicsTableView: UITableView!
  
  // MARK: Variables
  var locationManager = CLLocationManager()
  
  lazy var targetCircle: MapCircle = {
    let targetCircle = MapCircle()
    targetCircle.fillColor = .transparentWhite
    targetCircle.strokeColor = .macaroniAndCheese
    
    return targetCircle
  }()
  
  var targets: [Target] = []
  var targetsMarkers: [GMSMarker] = []
  var topics: [Topic] = []
  var firstTimeUpdatingLocation = true
  var selectedTargetMarker: GMSMarker?
  var showingTopicsTableView = false
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    makeNavigationBarTransparent()
    setLetterSpacing()
    setupMap()
    setupTargetForm()
    getTargetTopics()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if targets.isEmpty {
      getTargets()
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case .some("HomeToChatsSegue"):
      if let viewControllers = navigationController?.viewControllers {
        for viewController in viewControllers where viewController is ChatsViewController {
          viewController.removeFromParentViewController()
        }
      }
    case .some("HomeToUserProfile"):
      if let viewControllers = navigationController?.viewControllers {
        for viewController in viewControllers where viewController is UserProfileViewController {
          viewController.removeFromParentViewController()
        }
      }
    default:
      break
    }
  }
  
  // MARK: Actions
  @IBAction func tapOnCreateNewTargetButton(_ sender: Any) {
    if targets.count < 10 {
      disableMapGestures()
      showTargetForm(withFormType: .creation)
    } else {
      showMessageError(errorMessage: "You have exceeded the maximum amount of targets, please remove one before creating a new target.")
    }
  }
  
  // MARK: Functions
  private func setLetterSpacing() {
    let defaultSpacing: CGFloat = 1.6
    
    createNewTargetLabel.setSpacing(ofCharacter: defaultSpacing)
  }
  
  private func setupMap() {
    let coordinates = UserDataManager.getLastLocation()
    let zoom = coordinates.latitude != 0 && coordinates.longitude != 0 ? 16.0 : 1.0
    
    let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: Float(zoom))
    
    mapView.isMyLocationEnabled = true
    mapView.settings.compassButton = true
    mapView.delegate = self
    mapView.camera = camera
    mapView.bringSubview(toFront: newTargetLocationImageView)
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    addTargetCircle()
  }
  
  private func setupTargetForm() {
    targetFormView.delegate = self
  }
  
  private func getTargets() {
    TargetAPI.targets(success: { targets in
      self.targets = targets
      
      for target in targets {
        self.addTargetToMap(target)
      }
      
    }) { error in
      self.showMessageError(errorMessage: error.domain)
    }
  }
  
  fileprivate func getTargetTopics() {
    TargetAPI.topics(success: { topics in
      self.topics = topics
      self.topicsTableView.reloadData()
    }) { error in
      print(error.domain)
    }
  }
  
  fileprivate func addTargetToMap(_ target: Target) {
    let targetMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: target.lat, longitude: target.lng))
    
    targetMarker.iconView = targetMarkerView(withColor: .macaroniAndCheese, icon: target.topic.icon)
    targetMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    targetMarker.isFlat = true
    targetMarker.map = mapView
    targetMarker.userData = target
    
    targetsMarkers.append(targetMarker)
  }

  fileprivate func addTargetCircle() {
    let coordinates = mapView.camera.target
    
    targetCircle.position = coordinates
    targetCircle.radius = 50
    targetCircle.map = self.mapView
  }
  
  fileprivate func showTargetForm(withFormType formType: TargetFormType, target: Target? = nil) {
    targetFormView.formType = formType
    targetFormView.resetFields()
    targetFormView.target = target
    
    UIView.animate(withDuration: 0.35,
                   animations: {
                    let move = CGAffineTransform(translationX: 0, y: -self.targetFormView.frame.size.height)
                    self.targetFormView.transform = move
    })
  }
  
  fileprivate func hideTargetFormView() {
    if targetFormView.formType == .edition, let targetMarker = selectedTargetMarker, let selectedTarget = targetMarker.userData as? Target {
      targetMarker.iconView = targetMarkerView(withColor: .macaroniAndCheese, icon: selectedTarget.topic.icon)
      selectedTargetMarker = nil
    }
    
    UIView.animate(withDuration: 0.35,
                   animations: {
                    self.targetFormView.transform = .identity
    })
    enableMapGestures()
  }
  
  fileprivate func enableMapGestures() {
    mapView.settings.scrollGestures = true
    mapView.settings.tiltGestures = true
  }
  
  private func disableMapGestures() {
    mapView.settings.scrollGestures = false
    mapView.settings.tiltGestures = false
  }
  
  fileprivate func targetMarkerView(withColor color: UIColor, icon: URL?) -> UIView {
    let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    markerView.backgroundColor = color.withAlphaComponent(0.7)
    markerView.layer.cornerRadius = 30
    markerView.layer.masksToBounds = true
    
    let markerImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
    markerImageView.contentMode = .scaleAspectFit
    markerImageView.sd_setImage(with: icon)
    markerView.addSubview(markerImageView)
    
    return markerView
  }
}

extension HomeViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last
    
    if let coordinates = location?.coordinate {
      if firstTimeUpdatingLocation {
        firstTimeUpdatingLocation = false
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude,
                                              longitude: coordinates.longitude,
                                              zoom: 16.0)
        mapView.animate(to: camera)
        mapView.settings.myLocationButton = true
      }
      
      UserDataManager.storeLastLocation(coordinates)
    }
  }
}

extension HomeViewController: TargetFormDelegate {
  
  func saveTarget(area: Int, title: String, topic: Topic) {
    showSpinner(message: "Creating target")
    
    let coordinates = mapView.camera.target
    let newTarget = Target(radius: area, lat: coordinates.latitude, lng: coordinates.longitude, title: title, topic: topic, user: UserDataManager.getUserId())
    
    TargetAPI.createTarget(newTarget, success: { (target, matches) in
      self.hideSpinner()
      self.showNewTarget(target)
      self.hideTargetFormView()
      self.targetCircle.radius = 50
      
      if !matches.isEmpty {
        self.showNewMatchesDialog(withMatches: matches)
      }
    }) { (error) in
      self.hideSpinner()
      self.showMessageError(title: "Error", errorMessage: error.domain)
    }
    
  }
  
  func editTarget(area: Int, title: String, topic: Topic) {
    if let selectedTargetMarker = selectedTargetMarker, let targetToEdit = selectedTargetMarker.userData as? Target {
      guard let indexOfTargetToEdit = targets.index(of: targetToEdit) else {
        preconditionFailure("Target to edit not found")
      }
      
      targetToEdit.radius = area
      targetToEdit.title = title
      targetToEdit.topic = topic
      
      showSpinner(message: "Updating Target...")
      
      TargetAPI.updateTarget(target: targetToEdit, success: { (target, matches) in
        self.targets.remove(at: indexOfTargetToEdit)
        self.targets.append(target)
        
        let targetMarker = self.targetsMarkers[indexOfTargetToEdit]
        targetMarker.map = nil
        self.targetsMarkers.remove(at: indexOfTargetToEdit)
        
        self.addTargetToMap(target)
        self.hideSpinner()
        self.hideTargetFormView()
        
        if !matches.isEmpty {
          self.showNewMatchesDialog(withMatches: matches)
        }
      }) { error in
        self.hideSpinner()
        self.showMessageError(errorMessage: error.domain)
      }
    }
  }
  
  func cancelTargetCreation() {
    targetCircle.radius = 50
    hideTargetFormView()
  }
  
  func deleteTarget() {
    if let selectedTargetMarker = selectedTargetMarker, let targetToDelete = selectedTargetMarker.userData as? Target {
      guard let indexOfTargetToDelete = targets.index(of: targetToDelete) else {
        preconditionFailure("Target to delete not found")
      }
      
      showSpinner(message: "Deleting target")
      
      TargetAPI.removeTarget(target: targetToDelete, success: { _ in
        selectedTargetMarker.map = nil
        self.targets.remove(at: indexOfTargetToDelete)
        self.targetsMarkers.remove(at: indexOfTargetToDelete)
        self.hideSpinner()
        self.hideTargetFormView()
      }) { error in
        self.hideSpinner()
        self.showMessageError(title: "Error", errorMessage: error.domain)
      }
    }
  }
  
  func didTapOnSelectTopicField() {
    if topics.isEmpty {
      showMessageError(errorMessage: "Error fetching topics", actionTitle: "Try again") { _ in
        self.getTargetTopics()
      }
    } else {
      UIView.transition(with: topicsTableView,
                        duration: 0.35,
                        animations: {
                          self.topicsTableView.center.y -= self.topicsTableView.frame.size.height
      })
      
      showingTopicsTableView = true
    }
  }
  
  func didChangeTargetArea(_ area: Int) {
    targetCircle.radius = CLLocationDistance(area)
  }
  
  private func showNewTarget(_ target: Target) {
    targets.append(target)
    addTargetToMap(target)
  }
  
  private func showNewMatchesDialog(withMatches matches: [MatchConversation]) {
    let alert = NewMatchAlertView(withMatches: matches)
    alert.delegate = self
    alert.show(animated: true)
  }
}

extension HomeViewController: UITableViewDataSource {
  
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
    
    showingTopicsTableView = false
  }
}

extension HomeViewController: GMSMapViewDelegate {
  
  func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
    targetCircle.hide()
  }
  
  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
    targetCircle.hide()
  }
  
  func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
    targetCircle.show(inMap: self.mapView, radiusGoal: 50, position: position.target)
  }
  
  func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    if let target = marker.userData as? Target {
      
      if let selectedTargetMarker = selectedTargetMarker, let selectedTarget = selectedTargetMarker.userData as? Target {
        selectedTargetMarker.iconView = targetMarkerView(withColor: .macaroniAndCheese, icon: selectedTarget.topic.icon)
      }
      
      selectedTargetMarker = marker
      selectedTargetMarker?.iconView = targetMarkerView(withColor: .brightSkyBlue, icon: target.topic.icon)
      showTargetForm(withFormType: .edition, target: target)
    }
    
    return false
  }
  
  func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
    if targetFormView.formType == .edition && !showingTopicsTableView {
      hideTargetFormView()
    }
  }
}

extension HomeViewController: NewMatchAlertViewDelegate {
  
  func didTapStartChattingButton(withMatches matches: [MatchConversation]) {
    let match = matches.count == 1 ? matches.first : nil
    let viewControllerToPush = UIStoryboard.instantiateViewController(match != nil ? ChatViewController.self : ChatsViewController.self)
    
    navigationController?.pushViewController(viewControllerToPush!, animated: true)
  }
}
