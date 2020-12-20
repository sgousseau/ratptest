//
//  SplashScreenViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

class SplashScreenViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
        self?.performSegue(withIdentifier: Constants.Segue.splashToInput, sender: self)
      }
    }
}
