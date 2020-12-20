//
//  DisplayViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit



class DisplayViewController: UIViewController {
  
  @IBOutlet private weak var str1Label: UILabel!
  @IBOutlet private weak var str2Label: UILabel!
  @IBOutlet private weak var int1Label: UILabel!
  @IBOutlet private weak var int2Label: UILabel!
  @IBOutlet private weak var limitLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  
  var generator: StringGenerator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: DisplayCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
  }
}

extension DisplayViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Int(generator.parameters.limit) //The UITableView is limiting the generator with the Int type
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayCell.reuseIdentifier) as? DisplayCell else {
      return UITableViewCell()
    }
    
    cell.value = try? generator.get(at: indexPath.row)
    
    return cell
  }
}
