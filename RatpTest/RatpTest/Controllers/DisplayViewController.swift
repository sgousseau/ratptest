//
//  DisplayViewController.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import UIKit
import Combine

///The display list screen. It can overflow the tableView numberOfRows limit by using a DataSource object responsible for increasing the numberOfRows slowly as needed. Therefore, you can ask a display of `Int.max` items !
class DisplayViewController: UIViewController {
  
  @IBOutlet private weak var str1Label: UILabel!
  @IBOutlet private weak var str2Label: UILabel!
  @IBOutlet private weak var int1Label: UILabel!
  @IBOutlet private weak var int2Label: UILabel!
  @IBOutlet private weak var limitLabel: UILabel!
  @IBOutlet private weak var tableView: UITableView!
  
  ///The StringGenerator we use
  var generator: StringGenerator!
  
  ///The DataSource we use for tableView delegate & datasource methods
  private var dataSource: DataSource!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //At init, we construct the datasource object used with the tableView delegate and datasource methods
    //We use our StringGenerator object's limit property and get(at:) function as like a direct dependency & implementation injection
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

extension DisplayViewController {
  
  ///The fun begins here :-)
  class DataSource {
    
    ///The maximum numberOfItems to reach out
    private var limit: Int
    
    ///The item factory
    var getItem: (Int) -> String?
    
    ///The datasource onChange event callback
    var onChange: () -> Void
    
    ///The minimum getItemsCount() preload offset
    private var minOffset: Int = 300
    
    ///The bufferization delay, 300 is fine on a simulator
    private var processingDelayMS: Int = 300 //Can be adjusted depending on device performance
    
    ///The Combine subject used to handle defering computation of getItemsCount()
    private lazy var displayedItemsCount = CurrentValueSubject<Int, Never>(min(self.limit, self.minOffset))
    
    ///Our cancellables store
    private var cancellables = Set<AnyCancellable>()
    
    init(
      limit: Int,
      minOffset: Int = 300,
      getItem: @escaping (Int) -> String?,
      onChange: @escaping () -> Void
    ) {
      self.limit = limit
      self.minOffset = minOffset
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
    
    ///Asks datasource to re-compute getItemsCount(), upper value change filtering.
    func computeNumberOfRows(displayCount: Int) {
      self.displayedItemsCount.send(min(max(displayCount + self.minOffset, self.displayedItemsCount.value), self.limit))
    }
    
    ///Returns the currently computed maximum displayable count
    func getItemsCount() -> Int {
      print("Get count: \(self.displayedItemsCount.value)")
      return self.displayedItemsCount.value
    }
  }
}
