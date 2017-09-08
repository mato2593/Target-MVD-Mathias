//
//  TopicTableViewCell.swift
//  Target-MVD-Mathias
//
//  Created by Mathias Cabano on 9/8/17.
//  Copyright © 2017 TopTier labs. All rights reserved.
//

import UIKit

class TopicTableViewCell: UITableViewCell {
  
  // Mark: Outlets
  @IBOutlet weak var topicIconImageView: UIImageView!
  @IBOutlet weak var topicTitleLabel: UILabel!
  
  func setup(withTopic topic: Topic) {
    topicTitleLabel.text = topic.label
    topicIconImageView.sd_setImage(with: topic.icon)
    
    topicTitleLabel.setSpacing(ofCharacter: 2)
  }
  
}
