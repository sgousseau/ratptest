//
//  DisplayViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

typealias InputTuple = (str1: String, str2: String)

class DisplayViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
//      let inputToStatTag: (InputTuple) -> String = {
//        return ""
//      }
      Stats.live.addStat("")
    }
  
  func inputToStat(input: InputTuple) -> String {
    return ""
  }
}
