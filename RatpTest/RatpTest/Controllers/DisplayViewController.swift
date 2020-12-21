//
//  DisplayViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit
import Combine

class DisplayViewController: UIViewController {
  
  @IBOutlet private weak var str1Label: UILabel!
  @IBOutlet private weak var str2Label: UILabel!
  @IBOutlet private weak var int1Label: UILabel!
  @IBOutlet private weak var int2Label: UILabel!
  @IBOutlet private weak var limitLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  
  var generator: StringGenerator!
  private var dataSource: DataSource!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = DataSource(
      limit: generator.parameters.limit,
      getItem: { [weak self] in
        try? self?.generator.get(at: $0)
      },
      onChange: { [weak self] in
        self?.tableView.reloadData()
      }
    )
    
    tableView.register(UINib(nibName: "DisplayCell", bundle: nil), forCellReuseIdentifier: DisplayCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
  }
}

extension DisplayViewController {
  
  ///The fun begins here :-)
  class DataSource {
    private var limit: Int
    var getItem: (Int) -> String?
    var onChange: () -> Void
    
    private var minOffset: Int = 300
    private var processingDelayMS: Int = 300 //Can be adjusted depending on device performance
    private lazy var displayedItemsCount = CurrentValueSubject<Int, Never>(min(self.limit, self.minOffset))
    private var cancellables = Set<AnyCancellable>()
    
    init(
      limit: Int,
      getItem: @escaping (Int) -> String?,
      onChange: @escaping () -> Void
    ) {
      self.limit = limit
      self.getItem = getItem
      self.onChange = onChange
      
      //When a new value comes in, we filter the dupplicated states, then we buffer for 300ms (mainly for saving processing time) then we dispatch the changes.
      self.displayedItemsCount
        .removeDuplicates()
        .throttle(for: .milliseconds(processingDelayMS), scheduler: DispatchQueue.main, latest: true)
        .sink(receiveValue: { [weak self] count in
          self?.onChange()
        })
        .store(in: &cancellables)
    }
    
    func computeNumberOfRows(displayCount: Int) {
      self.displayedItemsCount.send(min(max(displayCount + self.minOffset, self.displayedItemsCount.value), self.limit))
    }
    
    func getItemsCount() -> Int {
      print("Get count: \(self.displayedItemsCount.value)")
      return self.displayedItemsCount.value
    }
  }
}

extension DisplayViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.getItemsCount()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: DisplayCell.reuseIdentifier) as? DisplayCell else {
      return UITableViewCell()
    }
    
    cell.value = dataSource.getItem(indexPath.row)
    
    return cell
  }
}

extension DisplayViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    dataSource.computeNumberOfRows(displayCount: indexPath.row)
  }
}
