//
//  RatpTestTests.swift
//  RatpTestTests
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import XCTest
@testable import RatpTest

class RatpTestTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testStringGeneratorBoundsErrors() throws {
    XCTAssertThrowsError(try StringGenerator(str1: "", str2: "", int1: UInt64.maxSquared, int2: UInt64.maxSquared, limit: UInt64.max)) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.parameterOverflow(value: UInt64.maxSquared, max: UInt64.maxSquared))
    }
  }
  
  func testStringGeneratorLimitErrors() throws {
    XCTAssertThrowsError(try StringGenerator(str1: "", str2: "", int1: 1, int2: 2, limit: 1)) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.limitTooLow)
    }
  }
  
  func testStringGeneratorIndexErrors() throws {
    XCTAssertNoThrow(try StringGenerator(str1: "", str2: "", int1: 1, int2: 2, limit: 2))
    let generator = try! StringGenerator(str1: "", str2: "", int1: 1, int2: 2, limit: 2)
    XCTAssertThrowsError(try generator.get(at: UInt64.max)) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.indexOutOfRange(index: UInt64.max, limit: 2))
    }
  }
  
  func testStringGenerator() throws {
    let max = UInt64(sqrt(Double(UInt64.max)))
    let int1 = UInt64.random(in: 0 ..< max)
    let int2 = UInt64.random(in: 0 ..< max)
    let limit = UInt64.random(in: (int1 * int2) ..< UInt64.max)
    
    let generator = try? StringGenerator(str1: "Fizz", str2: "Buzz", int1: int1, int2: int2, limit: limit)
    let fizzbuzz = try? generator?.get(at: (int1 * int2) - 1)
    
    XCTAssertNotNil(fizzbuzz)
    XCTAssert(fizzbuzz! == "FizzBuzz")
  }
}
