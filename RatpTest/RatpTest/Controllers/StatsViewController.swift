//
//  StatsViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit

class StatsViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  
  private let statsService: Stats = .live
  private var stats = [Stats.Stat]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "StatCell", bundle: nil), forCellReuseIdentifier: StatCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    stats = statsService.getStats()
  }
  
}

extension StatsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stats.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: StatCell.reuseIdentifier) as? StatCell else {
      return UITableViewCell()
    }
    
    cell.parameters = stats[indexPath.row].tag
    cell.hits = stats[indexPath.row].hit
    
    return cell
  }
}
