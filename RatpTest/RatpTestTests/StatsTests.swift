//
//  StatsTests.swift
//  RatpTestTests
//
//  Created by Sébastien Gousseau on 21/12/2020.
//

import XCTest
import Foundation

@testable import RatpTest

class StatsTests: XCTestCase {

    func testLiveStats() throws {
      UserDefaults.standard.set(nil, forKey: "tests_stats")
      UserDefaults.standard.synchronize()
      
      let statsService = Stats.live(storageKey: "tests_stats")
  
      statsService.addStat(.init("test_tag1"))
      statsService.addStat(.init("test_tag1"))
      statsService.addStat(.init("test_tag1"))
      
      statsService.addStat(.init("test_tag2"))
      statsService.addStat(.init("test_tag2"))
      statsService.addStat(.init("test_tag2"))
      
      let stats = statsService.getStats()
      
      XCTAssertTrue(stats.count == 2)
      XCTAssertTrue(stats[0].hits == 3)
      XCTAssertTrue(stats[1].hits == 3)
    }
}
