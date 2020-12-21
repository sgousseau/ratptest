//
//  RatpTestTests.swift
//  RatpTestTests
//
//  Created by Sébastien Gousseau on 19/12/2020.
//

import XCTest
@testable import RatpTest

class RatpTestTests: XCTestCase {
  
  func testStringGeneratorBoundsErrors() throws {
    XCTAssertThrowsError(try StringGenerator(parameters: (str1: "", str2: "", int1: Int.maxSquared, int2: Int.maxSquared, limit: Int.max))) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.parameterOverflow(value: Int.maxSquared, max: Int.maxSquared))
    }
  }
  
  func testStringGeneratorLimitErrors() throws {
    XCTAssertThrowsError(try StringGenerator(parameters: (str1: "", str2: "", int1: 1, int2: 2, limit: 1))) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.limitTooLow)
    }
  }
  
  func testStringGeneratorIndexErrors() throws {
    XCTAssertNoThrow(try StringGenerator(parameters: (str1: "", str2: "", int1: 1, int2: 2, limit: 2)))
    let generator = try! StringGenerator(parameters: (str1: "", str2: "", int1: 1, int2: 2, limit: 2))
    XCTAssertThrowsError(try generator.get(at: Int.max)) { error in
      XCTAssertEqual(error as! StringGenerator.StringGeneratorError, StringGenerator.StringGeneratorError.indexOutOfRange(index: Int.max, limit: 2))
    }
  }
  
  func testStringGenerator() throws {
    let max = Int(sqrt(Double(Int.max)))
    let int1 = Int.random(in: 0 ..< max)
    let int2 = Int.random(in: 0 ..< max)
    let limit = Int.random(in: (int1 * int2) ..< Int.max)
    
    let generator = try? StringGenerator(parameters: (str1: "Fizz", str2: "Buzz", int1: int1, int2: int2, limit: limit))
    let fizzbuzz = try? generator?.get(at: (int1 * int2) - 1)
    
    XCTAssertNotNil(fizzbuzz)
    XCTAssert(fizzbuzz! == "FizzBuzz")
  }
}
