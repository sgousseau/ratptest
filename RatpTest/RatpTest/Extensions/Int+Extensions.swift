//
//  Int+Extensions.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 21/12/2020.
//

import Foundation

extension Int {
  static var maxSquared: Int {
    return Int(sqrt(Double(Int.max)))
  }
}
