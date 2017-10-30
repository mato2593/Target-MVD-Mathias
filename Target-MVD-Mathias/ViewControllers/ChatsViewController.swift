//
//  ChatsViewController.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/22/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
  
  // MARK: Outlets
  @IBOutlet weak var chatsTableView: UITableView!
  
  // MARK: Variables
  var matches: [MatchConversation] = []
  
  // MARK: Constants
  let refreshControl = UIRefreshControl()
  
  // MARK: Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 10.0, *) {
      chatsTableView.refreshControl = refreshControl
    } else {
      chatsTableView.addSubview(refreshControl)
    }
    
    refreshControl.addTarget(self, action: #selector(fetchMatches), for: .valueChanged)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.backgroundColor = .clear
    fetchMatches()
  }
  
  // MARK: Actions
  @IBAction func tapOnMapBarButtonItem(_ sender: Any) {
    var homeViewController = getViewControllerFromNavigationStack(type: HomeViewController.self)
    
    if homeViewController == nil {
      homeViewController = UIStoryboard.instantiateViewController(HomeViewController.self)
    }
    
    navigationController?.setPushFromLeftTransition()
    navigationController?.pushViewController(homeViewController!, animated: true)
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let identifier = segue.identifier ?? ""
    
    switch identifier {
    case "ChatsToUserProfile":
      if let viewControllers = navigationController?.viewControllers {
        for viewController in viewControllers where viewController is UserProfileViewController {
          viewController.removeFromParentViewController()
        }
      }
    case "ChatSegue":
      if let cell = sender as? UITableViewCell, let indexPath = chatsTableView.indexPath(for: cell) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let chatViewController = segue.destination as? ChatViewController
        chatViewController?.match = matches[indexPath.row]
      }
    default:
      break
    }
  }
  
  // MARK: Functions
  func fetchMatches() {
    refreshControl.beginRefreshing()
    MatchesAPI.matches(success: { matches in
      self.refreshControl.endRefreshing()
      self.matches = matches
      self.chatsTableView.reloadData()
    }) { error in
      self.refreshControl.endRefreshing()
      self.showMessageError(title: "Error", errorMessage: error.domain)
    }
  }
  
  func newMessageReceived() {
    MatchesAPI.matches(success: { matches in
      self.matches = matches
      self.chatsTableView.reloadData()
    }) { _ in }
  }
}

extension ChatsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matches.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: ChatTableViewCell = {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as? ChatTableViewCell else {
        return ChatTableViewCell(style: .default, reuseIdentifier: "ChatCell")
      }
      return cell
    }()
    
    let match = matches[indexPath.row]
    cell.setup(withMatch: match)
    
    return cell
  }
}
