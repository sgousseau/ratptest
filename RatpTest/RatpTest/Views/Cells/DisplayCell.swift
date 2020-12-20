//
//  Cell.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

final class DisplayCell: UITableViewCell {
  static let reuseIdentifier = "DisplayCell"
  
  @IBOutlet private weak var label: UILabel!
  
  var value: String? {
    didSet {
      label.text = value
    }
  }
}
