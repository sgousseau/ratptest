//
//  DataSourceTests.swift
//  RatpTestTests
//
//  Created by Sébastien Gousseau on 21/12/2020.
//

import XCTest
@testable import RatpTest

class DataSourceTests: XCTestCase {
  
  func testDataSourceLimit() throws {
    let ds = DisplayViewController.DataSource(
      limit: 10,
      minOffset: 100,
      getItem: { _ in "item" },
      onChange: {
        
      }
    )
    //With an overflowing offset and an overflowing displayCount request, the limit is still 10.
    ds.computeNumberOfRows(displayCount: 20)
    
    XCTAssertTrue(ds.getItemsCount() == 10)
  }
  
  func testDataSourceIncremental() throws {
    let ds = DisplayViewController.DataSource(
      limit: 100,
      minOffset: 10,
      getItem: { _ in "item" },
      onChange: { }
    )
    
    ds.computeNumberOfRows(displayCount: 10)

    XCTAssertTrue(ds.getItemsCount() == 20) //incremented by displayCount + minOffset (for preload purposes, because it will trigger cellForRowAt(::) )
    
    ds.computeNumberOfRows(displayCount: 100) //End of list reached simulation
    
    XCTAssertTrue(ds.getItemsCount() == 100)
  }
}
