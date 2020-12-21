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
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    app = XCUIApplication()
    // We send a command line argument to our app,
    // to enable it to reset its state
    app.launchArguments.append("--uitesting")
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testApp() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    
    XCTAssertTrue(app.isDisplayingInput)

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}

extension XCUIApplication {
    var isDisplayingInput: Bool {
        return otherElements["inputView_aid"].exists
    }
}
