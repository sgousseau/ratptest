//
//  File.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation
import UIKit

extension UIAlertController {
  class func alert(
    title: String? = nil,
    message: String? = nil,
    on: UIViewController
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    on.present(alert, animated: true, completion: nil)
  }
}
