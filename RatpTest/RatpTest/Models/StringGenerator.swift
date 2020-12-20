//
//  StringGenerator.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation


extension UInt64 {
  static var maxSquared: UInt64 {
    return UInt64(sqrt(Double(UInt64.max)))
  }
}

struct StringGenerator {
  
  enum StringGeneratorError: Error, Equatable {
    case limitTooLow
    case parameterOverflow(value: UInt64, max: UInt64)
    case indexOutOfRange(index: UInt64, limit: UInt64)
  }
  
  let str1: String
  let str2: String
  let int1: UInt64
  let int2: UInt64
  let limit: UInt64
  
  init(str1: String, str2: String, int1: UInt64, int2: UInt64, limit: UInt64) throws {
    
    let max = UInt64.maxSquared
    
    guard int1 < max else {
      throw StringGeneratorError.parameterOverflow(value: int1, max: max)
    }
    
    guard int2 < max else {
      throw StringGeneratorError.parameterOverflow(value: int2, max: max)
    }
    
    guard (int1 * int2) <= limit else {
      throw StringGeneratorError.limitTooLow
    }
    
    self.str1 = str1
    self.str2 = str2
    self.int1 = int1
    self.int2 = int2
    self.limit = limit
  }
  
  func get(at: UInt64) throws -> String {
    guard at < limit else {
      throw StringGeneratorError.indexOutOfRange(index: at, limit: limit)
    }
    
    let n = at + 1
    let result = (n.isMultiple(of: int1) ? str1 : "") + (n.isMultiple(of: int2) ? str2 : "")
    
    return result.isEmpty ? "\(n)" : result
  }
}
