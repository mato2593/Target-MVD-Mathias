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
  var matches: [Match] = []
  
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
    
    fetchMatches()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier, identifier == "ChatsToUserProfile", let viewControllers = navigationController?.viewControllers {
      for viewController in viewControllers where viewController is UserProfileViewController {
        viewController.removeFromParentViewController()
      }
    }
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
