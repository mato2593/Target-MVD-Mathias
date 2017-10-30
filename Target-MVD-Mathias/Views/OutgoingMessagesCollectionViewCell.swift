//
//  OutgoingMessagesCollectionViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 10/25/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class OutgoingMessagesCollectionViewCell: MessagesCollectionViewCell {

  override func awakeFromNib() {
    super.awakeFromNib()
    
    messageTimestampLabel.textAlignment = .right
  }
}
