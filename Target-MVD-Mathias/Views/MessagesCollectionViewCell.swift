//
//  MessagesCollectionViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/25/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessagesCollectionViewCell: JSQMessagesCollectionViewCell {

  @IBOutlet weak var messageTimestampLabel: UILabel!
  
  override class func nib() -> UINib {
    let className = String(describing: self)
    return UINib(nibName: className, bundle: nil)
  }
  
  override class func cellReuseIdentifier() -> String {
    return String(describing: self)
  }
}
