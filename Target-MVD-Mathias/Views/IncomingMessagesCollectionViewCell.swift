//
//  IncomingMessagesCollectionViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/24/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class IncomingMessagesCollectionViewCell: JSQMessagesCollectionViewCellIncoming {

  @IBOutlet weak var messageTimeStampLabel: UILabel!

  override class func nib() -> UINib {
    return UINib(nibName: "IncomingMessagesCollectionViewCell", bundle: nil)
  }
  
  override class func cellReuseIdentifier() -> String {
    return "IncomingMessagesCollectionViewCell"
  }
}
