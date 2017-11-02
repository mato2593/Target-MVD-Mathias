//
//  DeleteTargetConfirmationDialog.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 11/2/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class DeleteTargetConfirmationDialog: UIView {

  // MARK: Outlets
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var dialogView: UIView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var targetView: UIView!
  @IBOutlet weak var targetImageView: UIImageView!
  @IBOutlet weak var targetTitleLabel: UILabel!
  
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  
  var target: Target
  
}
