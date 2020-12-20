//
//  StatCell.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation
import UIKit

final class StatCell: UITableViewCell {
  static let reuseIdentifier = "StatCell"
  
  @IBOutlet private weak var parametersLabel: UILabel!
  @IBOutlet private weak var hitsLabel: UILabel!
  
  var parameters: String = "" {
    didSet {
      parametersLabel.text = "\(parameters)"
    }
  }
  
  var hits: Int = 0 {
    didSet {
      hitsLabel.text = "\(hits)"
    }
  }
}
