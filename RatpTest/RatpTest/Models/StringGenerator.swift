//
//  StringGenerator.swift
//  RatpTest
//
//  Created by Sébastien Gousseau on 20/12/2020.
//

import Foundation



struct StringGenerator {
  
  typealias Parameters = (str1: String, str2: String, int1: Int, int2: Int, limit: Int)
  
  enum StringGeneratorError: Error, Equatable {
    case limitTooLow
    case parameterOverflow(value: Int, max: Int)
    case indexOutOfRange(index: Int, limit: Int)
    
    var description: String {
      switch self {
      case .limitTooLow:
        return "The given limit is too low"
      case let .parameterOverflow(value: value, max: max):
        return "The maximum possible value is \(max) but \(value) was given"
      case let .indexOutOfRange(index: index, limit: limit):
        return "The maximum index is \(limit - 1) but \(index) was given"
      }
    }
  }
  
  let parameters: Parameters
  
  init(parameters: Parameters) throws {
    
    let max = Int.maxSquared
    
    guard parameters.int1 < max else {
      throw StringGeneratorError.parameterOverflow(value: parameters.int1, max: max)
    }
    
    guard parameters.int2 < max else {
      throw StringGeneratorError.parameterOverflow(value: parameters.int2, max: max)
    }
    
    guard (parameters.int1 * parameters.int2) <= parameters.limit else {
      throw StringGeneratorError.limitTooLow
    }
    
    self.parameters = parameters
  }
  
  func get(at: Int) throws -> String {
    guard at < parameters.limit else {
      throw StringGeneratorError.indexOutOfRange(index: at, limit: parameters.limit)
    }
    
    let n = at + 1
    let result = (n.isMultiple(of: parameters.int1) ? parameters.str1 : "") + (n.isMultiple(of: parameters.int2) ? parameters.str2 : "")
    
    return result.isEmpty ? "\(n)" : result
  }
}
