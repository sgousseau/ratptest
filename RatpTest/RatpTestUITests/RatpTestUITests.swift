//
//  RatpTestUITests.swift
//  RatpTestUITests
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import XCTest

class RatpTestUITests: XCTestCase {
  var app: XCUIApplication!
  
  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("--uitesting")
  }
  
  func testApp() throws {
    app.launch()
    
    sleep(3)
    XCTAssertTrue(app.isDisplayingInput)
    
    app.buttons["goToDisplayButton_aid"].tap()
    
    sleep(2)
    XCTAssertTrue(app.isDisplayingList)

    app.buttons["goToStatsButton_aid"].tap()
    
    sleep(2)
    XCTAssertTrue(app.isDisplayingStats)
  }
}

extension XCUIApplication {
    var isDisplayingInput: Bool {
        return otherElements["inputView_aid"].exists
    }
  
  var isDisplayingList: Bool {
      return otherElements["displayView_aid"].exists
  }
  
  var isDisplayingStats: Bool {
      return otherElements["statsView_aid"].exists
  }
}
