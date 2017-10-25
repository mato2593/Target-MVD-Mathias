//
//  IncomingMessagesCollectionViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/24/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class IncomingMessagesCollectionViewCell: MessagesCollectionViewCell {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    messageTimestampLabel.textAlignment = .left
  }
}
