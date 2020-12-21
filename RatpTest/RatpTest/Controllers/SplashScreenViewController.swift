//
//  SplashScreenViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

class SplashScreenViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Any more animations or whatever here before going to the real app after 1sec delay.
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
      self?.performSegue(withIdentifier: Constants.Segue.splashToInput, sender: self)
    }
  }
}
